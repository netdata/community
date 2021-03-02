# Devenv

A Developer Environment (or devenv for short) is a workspace for developers to make changes without breaking anything in a live environment. 

In order to foster contribution for the Netdata Agent and it's various collectors, we created an image that is a devenv on it's own, a fully containerized environment where it has everything a developer needs to develop improvements on the Netdata Agent itself or it's collectors.

We have included all the dependencies that you need to build the Netdata Agent and it's collectors. Moreover, we have included helpful tools such as `python pip` and `flake8`. 

You only need to download your forked repositories and you can begin developing right away!

# Dockerfile

Inside this repository you can find the Dockerfile which is used to create the Docker Container. It is automatically published on [DockerHub](https://hub.docker.com/r/netdata/devenv), using a CI/CD pipeline based on GitHub Actions. 

# How to use the Devenv 

This devenv makes use of:
- [VS Code](https://code.visualstudio.com/), one of the most used open source editors on the Internet.
- [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) VS Code extension.
- [Docker](https://www.docker.com/).

## Quickstart

- [Download](https://code.visualstudio.com/download) VS Code.
- [Download](https://www.docker.com/products/docker-desktop) Docker.
- Fork the GitHub repository you want to contribute to, for example: [netdata/netdata](https://github.com/netdata/netdata)
- Clone the forked repository to your development machine, for example: `git clone https://github.com/odyslam/netdata netdata`.
- Clone the community repository, for example: `git clone https://github.com/netdata/community community`.
- `copy` and `paste` the `.devcontainer` folder inside the `netdata` directory. You will find the `.devcontainer` folder inside the community repository you just downloaded: `community/devenv/.devcontainer`.
- Open the `netdata` directory using VS Code and click on the popup as it is shown in the GIF bellow. It will re-open the directory from **inside** the Netdata Devenv.
  
![VS code example](https://microsoft.github.io/vscode-remote-release/images/remote-containers-readme.gif)

- This directory is synced in **real time** between your development machine and the developer container. Any file that you place inside the `netdata` directory, will be copied inside the `netdata` directory of the container.
  
**You are now ready to develop inside the Container!**

Finally, we have installed some  VS Code extensions that you might need, but you are free to [install](https://code.visualstudio.com/docs/remote/containers#_managing-extensions) more extensions inside the container. - 

> Note that any locally installed VS Code extension you might already have, will not work unless you install it **inside** the container.

## The hard way

You are free to `docker pull netdata/devenv` the container, attach a terminal session to it and start developing right away! The container has everything you need to get going.