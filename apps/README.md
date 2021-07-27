# Table of Contents
- Configuration Management
    - [consul-quickstart](apps/configuration-management/consul-quickstart/)
- Netdata Agent API
    -  [netdata-pandas](apps/netdata-agent-api/netdata-pandas/)
- Netdata Agent Deployment
  - [ansible-quickstart](apps/netdata-agent-deployment/ansible-quickstart/)
- [Developer Environment](apps/devenv)


# apps directory Structure

The directory is currently structured as follows. 

`apps/<category>/<sample_app>`

Each `<category>` and `<sample_app>` **must** have a README.md.

- `apps/category/README.md`: This README offers a simple explanation of the category (e.g what is configuration management)
- `apps/category/sample_app/README.md`: This README should offer instructions for the user on how to install, configure and use the `sample_app`.


# Contributing

- Make sure you take a look at the [Contributing Handbook](https://learn.netdata.cloud/contribute/handbook). It covers the whole range of contributinons for the Netdata ecosystem. We reference the guidelines about contributions, as also tips for specific areas (e.g docs). 
- If you need any help or feedback:
  - create a topic on our [Community Forums](https://community.netdata.cloud/c/agent-development/9). There is a whole category just for this. 
  - Join our [Discord server](https://discord.gg/mPZ6WZKKG2)

## Workflow
- Fork this repository
- Clone the forked repository locally
- Add your sample-application
    - Add relevant documentation by creating a README.md
    - Honour the existing directory structure: `apps/<category>/<sub-category>/<sample-app>`
- Push the changes to your fork, preferably to a branch and not master.
- PR the changes from your fork to this repository

### Sample Categories
- Configuration Management for Netdata Agent
- Chaos Engineering visualization with Netdata Agent
- Provisioning of a large number of Netdata Agents
- Netdata Agent integration with a 3rd-party application
    - By using Netdata Agent's API
    - By creating a new Netdata Agent collector
- ??

