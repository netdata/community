# Deploy Netdata with Ansible

Use this [Ansible](https://www.ansible.com/) playbook to quickly deploy the Netdata Agent to one or more remote nodes
and claim them to Netdata Cloud. Excellent for demo-ing Netdata's single-node and infrastructure monitoring
capabilities!

This Ansible playbook does the following to every node in the `hosts` file.

-   Install Netdata with the [kickstart
    script](https://learn.netdata.cloud/docs/agent/packaging/installer/methods/kickstart).
-   Claim the node to Netdata Cloud.
-   Copy a simple [`netdata.conf` configuration file](templates/netdata.conf.j2) into `/etc/netdata` on each host.

## Prerequisites

-   A Netdata Cloud account. [Sign in and create one](https://app.netdata.cloud) if you don't have one already.
-   One or more nodes running a supported operating system.

This playbook has been tested on:

-   Ubuntu 20.04
-   CentOS 7

## Quickstart

Here's how to run this playbook as quickly as possible.

First, and populate the `hosts` file with the IP addresses for your node(s). If you want, you can use the `hostname`
variable to set the node's name, which appears both on the local Agent dashboard and Netdata Cloud.

```
203.0.113.0   hostname=node-01
203.0.113.1   hostname=node-02 
```

Next, edit the `vars/main.yml` file to change the `claim_token` and `claim_rooms` variables. To find your `claim_token`
and `claim_room`, go to Netdata Cloud, then click on your Space's name in the top navigation, then click on `Manage your
Space`. Click on the `Nodes` tab in the panel that appears, which displays a script with `token` and `room` strings.

Finally, run the playbook.

```bash
ansible-playbook -i hosts tasks/main.yml
```

When the playbook finishes, you'll see your nodes appear in Netdata Cloud!

## Configuration

If you want to further configure your Netdata Agents, you can edit the existing values in `vars/main.yml`.
You should match you config keys under `config` to the netdata configuration sections mentioned [here](https://learn.netdata.cloud/docs/agent/daemon/config)

Plugins require `enabled: yes` to be created and configured.

Each entry should have a `data` key which include the configuration in the Netdata key = value format.

For example, if you want to increase metrics retention, increase `dbengine_multihost_disk_space` and run the playbook
again.

```
config:
  global:
    data: |-

      dbengine_multihost_disk_space = 2048

```
