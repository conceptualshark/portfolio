# Fides installation and deployment

## Summary

Designed to instruct users on production-level deployments of the open-source [Fides](https://ethyca.com/) platform, this guide assumed a level of technical understanding on the part of the reader, and was written as a series of how-to articles geared towards engineering personas.

Creating this guide not only involved meeting with stakeholders to ensure accuracy, but running the end-to-end installation independently as additional quality assurance.

---

## Overview

A production-ready instance of Fides can be deployed leveraging the cloud infrastructure your organization is most familiar with.

Fully deployed, Fides consists of the following individual systems:

1. **Hosted Database**: A [PostgreSQL](https://www.postgresql.org/) database used for permanent storage of configuration data.
2. **Hosted Cache**: A [Redis](https://redis.io/) database used as a temporary cache for task scheduling and execution.
3. **Fides Webserver**: The main application, including the Admin UI and all API endpoints.

## Requirements

The following minimum versions are required:

- **PostgreSQL**: 12+

- **Redis**: 6.2.0+

- **Python**: 3.8+

- **Docker:**  20.10.11+

## Set up the hosted database

Fides uses an application database for persistent storage. Any hosted PostgreSQL database that meets the current [project requirements](#requirements) is acceptable, as long as it's accessible.

Options include:

- A managed PostgreSQL database services (e.g., AWS RDS, GCP Cloud SQL, Azure Database)
- A self-hosted PostgreSQL Docker container with a persistent volume mount (e.g., a Kubernetes cluster)
- A self-hosted PostgreSQL server (e.g., an EC2 server)

!!! Tip
    As long as your database is accessible by your Fides webserver, there is no need to expose it to the public internet.

### Configure your database

Follow the documentation for the option of your choice to configure a production-grade PostgreSQL database. Once your database is created, take the following steps:

1. Create a **unique user** for Fides to use to access the database.
2. Assign your Fides user a secure password.
3. Create a **database** for application storage.
4. Keep track of your connection credentials for use in the next step.

### Update your Fides configuration

In the `[postgres]` section of your `fides.toml` configuration file, update the following values with those configured for your database:

| Variable | Example | Description |
| :---- | :------- | :----------- |
| `user` | `postgres` | The database user Fides will use to log in to the application database. |
| `password`| `fides` | The password for the Fides user. |
| `server` | `fides-db` | The hostname of the Postgres database server. |
| `port` | `5432` | The port at which the Postgres database will be accessible. |
| `db` | `fides` | The name of the Postgres database. |

## Set up the hosted cache

When privacy requests are running, Fides collects result data in a temporary Redis cache. This cache automatically expires to ensure personal data is never retained erroneously. 

Any hosted Redis database that meets the current [project requirements](#requirements) is acceptable, including:

- A Docker [Redis](https://hub.docker.com/_/redis) container 
- A managed service (e.g., AWS ElastiCache, GCP Memorystore, Azure Cache, Redis Cloud)

!!! Tip
    As long as your cache is accessible by your Fides webserver, there is no need to expose it to the public internet.

### Configure your cache

Follow the documentation for the option of your choice to configure a production-grade Redis cache. Once your cache is created, take the following steps::

1. Enable a password (via Redis [`AUTH`](https://redis.io/commands/auth)) to provide additional security.
2. Keep track of your connection credentials for use in the next step.

### Update your Fides configuration

In the `[redis]` section of your `fides.toml` configuration file, update the following values with those configured for your cache:

| Variable | Example | Description |
| :--- | :--- | :--- | 
| `host` | N/A | The network address for the application Redis cache. |
| `port` | `6379` | The port at which the application cache will be accessible. |
| `user`  | N/A | The user with which to login to the Redis cache. |
| `password` | N/A | The password with which to login to the Redis cache. |
| `db_index` | N/A | The application will use this index to cache data. |

## Set up the webserver

The Fides webserver is a [FastAPI](https://fastapi.tiangolo.com/) application with a [Uvicorn](https://www.uvicorn.org/) server to handle requests.

The host requirements for the webserver are:

- A general purpose webserver (for example, in AWS EC2, a t2.small or larger)
- Docker version 20.10.8 or newer

!!! Note
    The webserver has no persistent storage requirements. This is handled by the hosted database.

### Pull the docker image

Run the following command to pull the latest image from Ethyca's [DockerHub](https://hub.docker.com/r/ethyca/fides):

```sh
docker pull ethyca/fides
```

### Configure Fides

A number of environment variables are required for a minimum working configuration.

The configuration can be provided to your application through the following options:

- Create an `.env` file, and provite it to Docker via the [`--env-file {file}` option](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file)
- Provide individual variables with the `--env {VAR}` option
- Directly configure your variables with your Docker host

The following table represents the minimum required configuration:

| Config Variable | Example | Description |
|---|---|---|
| `FIDES__SECURITY__APP_ENCRYPTION_KEY` | N/A | An AES256 encryption key used for DB & JWE encryption. Must be exactly 32 characters (256 bits). |
| `FIDES__SECURITY__OAUTH_ROOT_CLIENT_ID` | fidesadmin | The client ID used for the "root" OAuth client. |
| `FIDES__SECURITY__OAUTH_ROOT_CLIENT_SECRET` | fidesadminsecret | The client secret used for the "root" OAuth client. |
| `FIDES__DATABASE__SERVER` | postgres.internal | The hostname for your database server. |
| `FIDES__DATABASE__PORT` | 5432 | The port for your database server. |
| `FIDES__DATABASE__USER` | fides | The username Fides will use to access the database. |
| `FIDES__DATABASE__PASSWORD` | fidessecret | The password Fides will use to access the database |
| `FIDES__DATABASE__DB` | fides | The postgres database name. |
| `FIDES__REDIS__HOST` | redis.internal | The hostname for your Redis server. |
| `FIDES__REDIS__PORT` | 6379 | The port for your Redis server. |
| `FIDES__REDIS__PASSWORD` | fidessecret | The password Fides will use to access Redis. |

### Start your server

Once configured, start your server with the following command:

```sh
docker run ethyca/fides -p 8080:8080
```

=== "Environment Variables"
    ```sh title="Start the server with environment variables"
    docker run \
    -p 8080:8080 \
    --env FIDES__SECURITY__APP_ENCRYPTION_KEY="athirtytwocharacterencryptionkey" \
    --env FIDES__SECURITY__OAUTH_ROOT_CLIENT_ID="fidesadmin" \
    --env FIDES__SECURITY__OAUTH_ROOT_CLIENT_SECRET="fidesadminsecret" \
    --env FIDES__DATABASE__SERVER="postgres.internal" \
    --env FIDES__DATABASE__PORT="5432" \
    --env FIDES__DATABASE__USER="fides" \
    --env FIDES__DATABASE__PASSWORD="fidessecret" \
    --env FIDES__DATABASE__DB="fides" \
    --env FIDES__REDIS__HOST="redis.internal" \
    --env FIDES__REDIS__PORT=6379 \
    --env FIDES__REDIS__PASSWORD="fidessecret" \
    ethyca/fides
    ```

=== "`.env` file"
    ``` title="Start the server with an <code>env</code> file"
    docker run \
    -p 8080:8080 \
    --env-file=config.env \
    ethyca/fides
    ```

    ```sh title="<code>config.env</code>"
    FIDES__SECURITY__APP_ENCRYPTION_KEY="athirtytwocharacterencryptionkey" 
    FIDES__SECURITY__OAUTH_ROOT_CLIENT_ID="fidesadmin" 
    FIDES__SECURITY__OAUTH_ROOT_CLIENT_SECRET="fidesadminsecret" 
    FIDES__DATABASE__SERVER="postgres.internal" 
    FIDES__DATABASE__PORT="5432" 
    FIDES__DATABASE__USER="fides" 
    FIDES__DATABASE__PASSWORD="fidessecret" 
    FIDES__DATABASE__DB="fides" 
    FIDES__REDIS__HOST="redis.internal" 
    FIDES__REDIS__PORT=6379 
    FIDES__REDIS__PASSWORD="fidessecret"
    ```

!!! Note
    There is no need for a persistent volume mount. The webserver is fully ephemeral, and relies on the database for its permanent state.

### Test the webserver

To test that your server is running, visit `http://{server_url}/health` in your browser (for example, `http://0.0.0.0:8080/health`).

```title="A healthy webserver response"
{"webserver": "healthy", "database": "healthy", "cache": "healthy"}
```

You can also visit the hosted UI at `http://{server_url}/`.

## Set up the Privacy Center (Optional)

!!! Info
    For more information on how to use and customize your Privacy Center, see [Configure the Privacy Center](./guide-privacy-center.md).

Ensure that Docker is running on your host, and satisfies the [minimum requirements](#requirements).

Run the following command to pull the latest image from Ethyca's [DockerHub](https://hub.docker.com/r/ethyca/fides):

```sh
docker pull ethyca/fides-privacy-center
```

Once pulled, run the following within your project to start the server: 

```sh
docker run --rm \
  -v $(pwd)/config:/app/config \
  -p 3000:3000 ethyca/fides-privacy-center:latest
```
