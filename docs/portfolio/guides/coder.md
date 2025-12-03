---
title: Remote development with Coder.com
description: Comprehensive guide for accessing and configuring Coder.com remote development environments at CoreWeave, covering workspace provisioning and multiple access methods.
---

# Remote development with Coder.com

## Summary

This guide supported CoreWeave's evaluation of [Coder.com](https://coder.com/) for remote development by providing comprehensive documentation for trial participants. Targeting engineers across the organization, the guide walks users through accessing CoreWeave's Coder deployment, provisioning workspaces, and configuring development environments across multiple tools (CLI, VS Code, JetBrains, web interface).

Creating this guide involved hands-on testing of the platform to document setup procedures, configuration options, and workflows that trial participants would need to effectively evaluate Coder for enterprise use.

!!! note Internal content

    This guide was created for internal company use. Links to internal resources and authentication portals have been replaced with placeholders.

---

## Overview

[Coder.com](https://coder.com) provides remote workspace environments for secure development, offering persistent home directories independent of local machines, and access to compute resources beyond local hardware capabilities.

### Use cases

Coder should primarily be used for any task that requires remote development, particularly in cases that:

- require more compute than is provided by your machine
- require testing support or virtualization not available on your machine

Coder workspaces can be accessed in multiple ways to better fit or supplement your current workflows.

---

## Access CoreWeave’s Coder deployment

Coder provides both a web application and a CLI in order to log in to CoreWeave’s deployment. Instructions for both options are outlined below.

!!! note
    Ensure you are logged into **BlastShield** prior to beginning.

### Install and log in with the Coder CLI

The CoreWeave installation page can be found at [internal URL](#).

1. Download and install Coder via the Linux/macOS installation script below:

    ```bash
    curl -fsSL [internal URL] | sh
    ```

2. Use the following command to log in to the CoreWeave Coder deployment:

    ```bash
    coder login [internal URL]
    ```

    Your browser will automatically open [internal URL](#).

3. Select **OpenID Connect**, and use your CoreWeave credentials to log into Okta.
4. Click **Copy session token**, and paste the token in your terminal when prompted.

Once successfully logged in, your Coder workspaces can be accessed via [SSH](https://coder.com/docs/user-guides/workspace-access#ssh), and are available in the web application at [internal URL](#).

### Log in with the web application

1. Navigate to CoreWeave’s Coder deployment at [internal URL](#).
2. Select **OpenID Connect**.
3. Use your CoreWeave credentials to log into Okta. You are automatically redirected to Coder when authentication is complete.

## Create your initial workspaces

A [Coder workspace](https://coder.com/docs/user-guides/workspace-management) is the remote environment created and persisted for your work. Each workspace is created from a [template](https://coder.com/docs/admin/templates), allowing environment configurations to be replicated across individuals, teams, and workflows.

### Provision your home directory

Creating a persistent home directory allows you to optionally mount the same home directory into multiple workspaces. Without using a persistent home directory, any files or folders stored in your workspace will be lost when that workspace is terminated.

1. From the **Workspaces** landing page, click **New workspace**, and select **Create Persistent Home Directory**.
2. Provide the following information for your workspace:
    - **Workspace Name:** A unique name to identify your home directory workspace.
    - **Parameters:** Select the size of the home disk in GB.
3. Click **Create workspace** when finished.

!!! warning "Workspace persistence"
    Deleting your home directory workspace will delete the persistent directory volume.

### Provision a development workspace

Once your persistent home directory is provisioned, you can create a new development workspace.

1.  From the **Workspaces** landing page, click **New workspace**, and select **Base Template** to base your new workspace on.
2.  Provide a **Workspace Name** to identify your workspace, and the following **Parameters**:
    - **Dotfiles URL:** Provide the URL to your [Dotfiles](https://dotfiles.github.io/) repository. This repository must be public.

        To avoid making your Dotfiles public, clone your Dotfiles repository and copy the files manually into your Coder home directory.
        
        The following example copies local `.gitconfig` and `.gitignore_global` settings into your workspace’s `:/home/coder` directory:
        
        ```bash
        scp .gitconfig .gitignore_global coder@main.<workspaceName>.<username>.coder:/home/coder
        ```

    - **Jetbrains IDE:** Select either GoLand or PyCharm to access your workspace through your IDE and JetBrains Gateway.
    - **CPU and Memory:** Select the resources required by your use case.
    - **Mount Persistent Home Directory?** By default, a new workspace will mount your persistent home directory, and all work saved in your `/home/your-username` directory can persist across multiple workspaces.

        **Unchecking this option creates an ephemeral home directory**. An ephemeral home directory does not have access to your persistent home directory, and will not store its contents past workspace termination.
        
        An ephemeral home directory may be useful in cases that require temporary or impermanent volumes, like CI/CD pipelines.

3.  Click **Create workspace** when finished.

For more information on what features are pre-installed with the base template, see the [base template features](#base-template-features).

## Access an existing workspace

Coder provides multiple methods of accessing your workspace for development, including a native terminal, SSH configuration, and a Visual Studio Code extension.

Common and configured connections can be found by viewing the workspace’s dashboard.

For more information and options, see the Coder documentation on [accessing a workspace](https://coder.com/docs/user-guides/workspace-access).

### Via SSH

1.  From your workspace’s dashboard, select **Connect via SSH**.
2.  Run the provided commands in your terminal to connect:

    ```bash
    coder config-ssh
    ```

    When prompted in your terminal, type `yes` and press enter to confirm.

    The second command is unique to your username and workspace:

    ```bash
    ssh main.<workspaceName>.<username>.coder
    ```

    Your workspace is now available via SSH, and can be accessed with the following command:

    ```bash
    ssh -A coder.<workspaceName>
    ```

    If your workspace does not have access to your `.gitconfig`, ensure your username and email address are set:

    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"
    ```

    For more information, see the Coder documentation on [connecting via SSH](https://coder.com/docs/user-guides/workspace-access#ssh).

!!! error "Error: git@github.com: Permission denied (publickey)."
    The above error occurs when Coder is unable to authenticate with git. To push to or pull from GitHub, include the `-A` flag with your ssh command. This flag allows SSH to use your local keys for authentication. You can also follow the steps provided in the error message to add the generated public key to GitHub.

### Via Visual Studio Code

Coder connects to your local Visual Studio Code installation through the [Coder Remote](https://github.com/coder/vscode-coder) extension.

1. From your workspace’s dashboard, select **VS Code Desktop** to open your workspace.
2. When prompted, allow the extension to install. VS Code automatically authenticates with Coder and connects to your workspace.

For more information, see the Coder documentation on [connecting to Visual Studio Code](https://coder.com/docs/user-guides/workspace-access/vscode).

### Via JetBrains Gateway

To access your workspace through PyCharm or GoLand, follow the Coder instructions to integrate with [JetBrains Gateway](http://coder.com/docs/user-guides/workspace-access/jetbrains/gateway).

Once authenticated and configured, your Coder workspace is available through JetBrains Gateway and your preferred IDE.

### Via the web application

Within the Coder web application, your workspace can be accessed via a native terminal, or an in-browser deployment of Visual Studio Code.

To connect via the native terminal:

1. In your workspace’s dashboard, select **Terminal**.
2. A new window launches an in-browser terminal and automatically connects to your workspace.

To connect via [code-server](https://github.com/coder/code-server), the in-browser version of VS Code:

1. In your workspace’s dashboard, select **code-server**.
2. A new window launches the in-browser version of VS Code and automatically connects to your workspace.

---

## Configure and use your workspace

### Access your home folder

Within your workspace, your home directory is located at `/home/coder`, and can be accessed using `cd`.

### Base template features

The base template for your development workspace includes the following by default:

- docker (`dockerd` already running)
- kind
- kubectl
- Nested virtualization via `qemu-kvm`

### Data persistence

!!! warning "Data Persistence"
    Workspaces only persist data stored in the user’s home directory, and this work is **not saved when the workspace is terminated**. To persist work across multiple workspaces and after a workspace is terminated, ensure you have created a persistent home directory.

To avoid losing any work when your workspace is terminated, the following options are recommended:

- Create a **persistent home directory**, and store all work within it.
- Create a dedicated folder within your home directory (for example, `~/bin` or `~/.local`) to store custom binaries or scripts. Adjust your `PATH` environment variable as needed to access software installed in these custom directories.
- Avoid installing software or saving work in directories such as `/opt`, `/tmp`, or other system paths.

### Configure port forwarding

Use the following command to forward ports from your Coder workspace to your local machine:

```bash
coder port-forward <workspace-name> --tcp <remote-port>:<local-port>
```

| Argument/flag | Description |
| :--- | :--- |
| `<workspace-name>` | The name of your workspace. |
| `<remote-port>` | The remote (workspace) TCP port you would like to forward. |
| `<local-port>` | The port number on your local machine. |

For example, the following command forwards port 8000 from the `your-workspace` Coder workspace to port 8080 on your local machine:

```bash
coder port-forward your-workspace --tcp 8000:8080
```

For more information, see the Coder documentation to [configure port forwarding](https://www.google.com/search?q=https://coder.com/docs/user-guides/workspace-access/port-forwarding%23port-forwarding).