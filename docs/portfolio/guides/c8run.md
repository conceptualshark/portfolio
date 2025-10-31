---
title: "Camunda 8 Run quickstart"
description: This quickstart guides application developers through deploying Camunda 8 Self-Managed to a local orchestration cluster using Camunda 8 Run.
---

# Install and use Camunda 8 Run

## Summary

Designed to enable developers to deploy [Camunda 8](https://docs.camunda.io/) Self-Managed locally using Camunda 8 Run, this guide simplifies the complex process of running orchestration clusters. Written as a comprehensive installation, configuration, and getting started resource, it targets developers needing local environments for testing and development.

Creating this guide involved hands-on testing alongside the primary subject matter expert, identifying documentation needs through independent deployment, and serving as the application's principal tester during initial development stages.

---

## Overview

!!! warning "Production use"
    Camunda 8 Run is not supported for production use.

Camunda 8 Run enables you to run an Orchestration cluster, including Zeebe, Operate, Tasklist, Identity, and Elasticsearch, with minimal configuration. It is intended for developers who want to model BPMN diagrams, deploy them, and interact with running process instances in a simple environment. This guide explains how to get started on your local or virtual machine.

Camunda 8 Run includes the following:

- Orchestration Cluster
- Connectors
- Elasticsearch

Camunda 8 Run also supports document storage and management with document handling.

## Prerequisites

- **OpenJDK 21–23**: Required for running Camunda 8 as a Java application.
- **Docker 20.10.21+**: Required for running Camunda 8 via Docker Compose.
- **Desktop Modeler**
- **If using Ubuntu**: Ubuntu 22.04 or newer

!!! note "Java setup"
    After installing OpenJDK, ensure `JAVA_HOME` is set by running `java -version` in a **new** terminal.

    If no version of Java is found, follow your chosen installation's instructions for setting `JAVA_HOME` before continuing.

## Install and start Camunda 8 Run

1. Download the latest release of [Camunda 8 Run](https://downloads.camunda.cloud/release/camunda/c8run/8.8/) for your operating system and architecture. Opening the `.tgz` file extracts the Camunda 8 Run script into a new directory.
2. Navigate to the new `c8run` directory.
3. Start Camunda 8 Run by running one of the following in your terminal:
    - **On Mac and Linux**:
          - Run the helper script: `./start.sh`
          - Or use the CLI command: `./c8run start`
    - **On Windows**:
          - Use the CLI command: `.\c8run.exe start`

On a successful startup, a browser window for Operate will open automatically. Operate can be accessed manually at [`http://localhost:8080/operate`](http://localhost:8080/operate).

### Configuration options

The following command line options allow for additional overrides at startup.

For more advanced and permanent configuration options, modify the default `configuration/application.yaml` or supply a custom file using the `--config` flag.

| Argument                   | Description                                                                                                                                                                                                                                                                                                                                                                                                                   |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--config <path>`          | Applies the specified Zeebe `application.yaml`.                                                                                                                                                                                                                                                                                        |
| `--username <arg>`         | Configures the first user’s username as `<arg>`.                                                                                                                                                                                                                                                                                                                                                                              |
| `--password <arg>`         | Configures the first user’s password as `<arg>`.                                                                                                                                                                                                                                                                                                                                                                              |
| `--keystore <arg>`         | Configures the TLS certificate for HTTPS. If not specified, HTTP is used. For more information, see [enabling TLS](#enable-tls).                                                                                                                                                                                                                                                                                              |
| `--keystorePassword <arg>` | Provides the password for the JKS keystore file.                                                                                                                                                                                                                                                                                                                                                                              |
| `--port <arg>`             | Sets the Camunda core port (default: `8080`).                                                                                                                                                                                                                                                                                                                                                                                 |
| `--log-level <arg>`        | Sets the log level for the Camunda core.                                                                                                                                                                                                                                                                                                                                                                                      |
| `--docker`                 | Downloads and runs the Camunda Docker Compose distribution. This option provide an easy shortcut to run Camunda in Docker Compose, but additional Camunda 8 Run options are not supported and will be ignored. See the [shutdown script](#shut-down-camunda-8-run) for information on stopping the Docker application. |
| `--disable-elasticsearch`  | Prevents the built-in Elasticsearch from starting. Ensure another Elasticsearch instance is provided via `--config`. See the [external Elasticsearch](#start-external-elasticsearch) section for details.                                                                                                                                                                                                                     |

## Work with Camunda 8 Run

### Access Camunda components

By default, Camunda 8 Run uses basic authentication for all web interfaces. OIDC and Keycloak are not included in this distribution.

Log in to all web interfaces with the default credentials:

- **Username:** `demo`
- **Password:** `demo`

The Camunda 8 web interfaces are available at:

- **Operate:** [`http://localhost:8080/operate`](http://localhost:8080/operate)
- **Tasklist:** [`http://localhost:8080/tasklist`](http://localhost:8080/tasklist)
- **Identity:** [`http://localhost:8080/identity`](http://localhost:8080/identity)

The following components do not have a web interface, but are available at the following endpoints:

- **Orchestration Cluster REST API:** [`http://localhost:8080/v2/`](http://localhost:8080/v2/)
- **Inbound Connectors API:** [`http://localhost:8086/`](http://localhost:8086/)
- **Zeebe API (gRPC):** [`http://localhost:26500/`](http://localhost:26500/)
- **Metrics (Prometheus):** [`http://localhost:9600/actuator/prometheus`](http://localhost:9600/actuator/prometheus)
- **Swagger UI (API Explorer):** [`http://localhost:8080/swagger-ui/index.html`](http://localhost:8080/swagger-ui/index.html)

### Deploy diagrams from Desktop Modeler

!!! note
    Make sure you have installed Desktop Modeler before continuing.

To deploy BPMN diagrams from Desktop Modeler, use the following configuration in the Deployment interface:

- **Target:** Self-Managed
- **Cluster endpoint:** `http://localhost:26500`
- **Authentication:** None

A success notification will display when complete. Start a new process instance to view your running process in Operate.

### Use built-in and custom connectors

Desktop Modeler automatically fetches templates for pre-built connectors. Custom connectors can also be added to your Camunda 8 Run distribution.

To add a custom connector:

1. Place the connector’s `.jar` file in the `/custom_connectors` folder within the `/c8run` directory.
2. Place the element template in the appropriate folder for your installation.

Once configured, your connectors are available for use in Modeler.

### Configure Connector secrets

Connector Secrets can be provided as environment variables by adding them to an `.env` file in Camunda 8 Run's root folder.

When starting Camunda 8 Run with the `--docker` option, add the connector secrets to the `connector-secrets.txt` file in the docker-compose folder.

### Enable authentication and authorization

By default, Camunda 8 Run [configures authentication](#access-camunda-components) for web interfaces, but all API endpoints are open and do not require authentication. To secure APIs, authorization but be enabled in your `application.yaml`.

Ensure the following is set either in your existing `application.yaml`, or create a new `application.yaml` in the `/c8run` folder:

```yaml
camunda:
  security:
    authentication:
      # Require authentication for API requests
      unprotected-api: false
    authorizations:
      # Enable authorization checks
      enabled: true
```

Start Camunda 8 Run by passing your new configuration at startup using the [`--config` flag](#configuration-options):

```bash
./start.sh --config application.yaml
```

Once enabled, API requests must include valid credentials. For example, the following `curl` command includes `-u demo:demo` to include the default username and password:

```shell
curl --request GET 'http://localhost:8080/v2/topology'  \
  -u demo:demo \
  --header 'Content-Type: application/json' \
  --data-raw '{}'
```

## Shut down Camunda 8 Run

To shut down Camunda 8 Run and end all running processes, run `./shutdown.sh` (or `.\c8run.exe stop` on Windows) from the `c8run` directory.

To shut down the Camunda 8 Run Docker distribution, use `./shutdown.sh --docker` (or `.\c8run.exe stop --docker` on Windows).

## Advanced options

### Enable TLS

TLS can be enabled by providing a local keystore file using the `--keystore` argument at startup. Camunda 8 Run accepts `.jks` certificate files.
Although C8Run supports TLS, this is intended only for testing.

### Access metrics

Metrics are enabled in Camunda 8 Run by default and can be accessed at [`http://localhost:9600/actuator/prometheus`](http://localhost:9600/actuator/prometheus).

### Start external Elasticsearch

By default, Camunda 8 Run starts with its own embedded Elasticsearch instance. To use an external or pre-existing instance, Camunda 8 Run can be started with Elasticsearch disabled and pointed to your existing instance.

1. Start a single-node Elasticsearch container with security disabled:

    ```bash
    docker run \
        -m 1GB \
        -d \
        --name elasticsearch \
        -p 9200:9200 \
        -p 9300:9300 \
        -e "discovery.type=single-node" \
        -e "xpack.security.enabled=false" \
        elasticsearch:8.15.2
    ```

2. Update or create creating an `application.yaml` file that points to your external Elasticsearch:

    ```yaml
    camunda:
        data:
        secondary-storage:
            elasticsearch:
            url: "http://127.0.0.1:9200/"
    ```

3. Start Camunda 8 Run with the `--disable-elasticsearch` flag to prevent it from starting its own instance, and provide your new configuration:

    ```bash
    ./start.sh --disable-elasticsearch --config application.yaml
    ```