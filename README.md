# Netdata Community

Welcome to the community-curated repository of Netdata. 

Name of the game is simple, aggregate sample-applications that super-charge the Netdata experience and can serve as boilerplate or examples.

# Table of Contents
- Configuration Management
    - [consul-quickstart](/configuration-management/consul-quickstart/)
- Netdata Agent API
    -  [netdata-pandas](/netdata-agent-api/netdata-pandas/)
- Netdata Agent Deployment
  - [ansible-quickstart](/netdata-agent-deployment/ansible-quickstart/)
- [Developer Environment](/devenv)


# Repository Structure

The repository is currently structured as follows. Since this is a community-based repository, the structure can change based on feedback.

`/<category>/<sample_app>`

Each `<category>` and `<sample_app>` **must** have a README.md.

- `/category/README.md`: This README offers a simple explanation of the category (e.g what is configuration management)
- `/category/sample_app/README.md`: This README should offer instructions for the user on how to install, configure and use the `sample_app`.


# Contributing

- Make sure you take a look at the [Contributing Handbook](https://learn.netdata.cloud/contribute/handbook). It covers the whole range of contributinons for the Netdata ecosystem. We reference the guidelines about contributions, as also tips for specific areas (e.g docs). 
- For the Community repository speicifically, here are a couple of ideas:
    - Improve an existing Sample-App in code or documentation
    - Submit a new sample-app in an existing category
    - Submit a new sample app in a new category

## Workflow
- Fork this repository
- Clone the forked repository locally
- Add your sample-application
    - Add relevant documentation by creating a README.md
    - Honour the existing directory structure: `<category>/<sub-category>/<sample-app>`
- Push the changes to your fork, preferablly to a branch and not master.
- PR the changes from your fork to this repository

### Sample Categories
- Configuration Management for Netdata Agent
- Chaos Engineering visualization with Netdata Agent
- Provisioning of a large number of Netdata Agents
- Netdata Agent integration with a 3rd-party application
    - By using Netdata Agent's API
    - By creating a new Netdata Agent collector
- ??

# License

MIT License 

# Code of Conduct

This repository is part of the Netdata organization, thus the Netdata [Code of Conduct](https://learn.netdata.cloud/contribute/code-of-conduct) applies.
