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


# Repository Structure

The repository is currently structured as follows. Since this is a community-based repository, the structure can change based on feedback.

`/<category>/<sample_app>`

Each `<category>` and `<sample_app>` **must** have a README.md.

- `/category/README.md`: This README offers a simple explanation of the category (e.g what is configuration management)
- `/category/sample_app/README.md`: This README should offer instructions for the user on how to install, configure and use the `sample_app`.


# Contributing

This repository will be evolved alongside the community, with more specific contributing guidelines being on their way.

Until then, simply fork the repository, add your contribution, and perform a PR. 

## Ideas for contribution
- Improve an existing Sample-App in code or documentation
- Submit a new sample-app in an existing category
- Submit a new sample app in a new category

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
Read our [CODE_OF_CONDUCT.md](/CODE_OF_CONDUCT.md)
