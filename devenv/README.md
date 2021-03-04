# Devenv

A Developer Environment (or devenv for short) is a workspace for developers to make changes without breaking anything in a live environment. 

In order to foster contribution for the Netdata Agent and it's various collectors, we created an image that is a devenv on its own, a fully containerized environment that has everything a developer needs to develop improvements on the Netdata Agent itself, or its collectors.

We have included all the dependencies that you need to build the Netdata Agent and its collectors. We have additionally included many of the tools we use for checking PRs, including various linters like `flake8` and `shellcheck`.
You only need to download your forked repositories and you can begin developing right away!

# Dockerfile

Inside this repository you can find the Dockerfile which is used to create the development environment Docker image. It is automatically published on [DockerHub](https://hub.docker.com/r/netdata/devenv), using a CI/CD pipeline based on GitHub Actions. 

# How to use the Devenv 

This devenv makes use of:
- Required:
  - [Docker](https://www.docker.com/)
- Optional:
  - [VS Code](https://code.visualstudio.com/), one of the most used open source editors on the Internet.
  - [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) VS Code extension.

## Quickstart

- [Download](https://code.visualstudio.com/download) VS Code.
- [Download](https://www.docker.com/products/docker-desktop) Docker.
- Fork the GitHub repository you want to contribute to, e.g [netdata/netdata](https://github.com/netdata/netdata)
- Clone the forked repository to your development machine: `git clone https://github.com/odyslam/netdata netdata`.
- Clone the community repository: `git clone https://github.com/netdata/community community`.
- `copy` and `paste` the `.devcontainer` folder inside the `netdata` directory. You will find the `.devcontainer` folder inside the community repository you just downloaded: `community/devenv/.devcontainer`.
- Open the `netdata` directory using VS Code and click on the popup as it is shown in the GIF bellow. It will re-open the directory from **inside** the Netdata Devenv.
  
![VS code](remote-containers-readme.gif)

- This directory is synced in **real time** between your development machine and the developer container. Any file that you place inside the `netdata` directory, will be copied inside the `netdata` directory of the container.
  
**You are now ready to develop inside the Container!**

Finally, we have installed some  VS Code extensions that you might need, but you are free to [install](https://code.visualstudio.com/docs/remote/containers#_managing-extensions) more extensions inside the container. - 

> Note that any locally installed VS Code extension you might already have, will not work unless you install it **inside** the container.

## The hard way

You are free to `docker pull netdata/devenv` the container, attach a terminal session to it and start developing right away! The container has everything you need to get going.

# Supported Netdata repositories

The devenv includes all the dependencies required to develop for the following repositories:
- netdata/netdata 
- netdata/dashboard
- netdata/go.d.plugin
- netdata/helmchart
