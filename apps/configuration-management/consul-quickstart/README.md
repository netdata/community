# Configuration Management with Consul


Consul is a Hashicorp based tool for discovering and configuring a variety of different services in the infrastructure.

**Main Features:**
- Service Discovery
- Health Check Status
- Key/Value(KV) Store
- Multi Datacenter Deployment
- Web UI

**Documentation:** [Introduction to Consul](https://www.consul.io/docs/intro).

# Consul & Netdata

While Consul has many features and a number of users already use it in their infrastructure, we will be focusing on a particular functionality, that of the `KV store`.

We will populate the `KV store` with the configuration variables that we wish to set and change dynamically in Netdata Agent.

## Consul-Template

While the configuration variables will live inside the Consul agent, in order to populate the configuration files of Netdata Agent, we will need [consul-template](https://github.com/hashicorp/consul-template). 

It's a simple CLI tool that populates a template file from the `KV Store` of a Consul Agent and then outputs the file to the pre-defined directory. Any change to the `KV Store`, will be picked up and a new file will be outputed. Netdata Agent will be restarted everytime to make sure that the change is picked up.

**Disclaimer**: Read the documentation of Consul-Template. It's a powerful tool that allows for all sorts of customization and dynamic control of the configuration, not just with simple `Key/Value` combinations. This example is dead-simple and does not make justice to the tool.

## Consul best-practices

According to consul [reference architecture](https://learn.hashicorp.com/tutorials/consul/reference-architecture), it is assumed that every system runs it's own Consul Agent, creating a cluster where a number of Consul Agents are defined as Servers and participate in the quorum of the system.

The cluster shares KV stores and other characteristics, so the changes propagate in the system.

Thus, this tutorial assumes that for every Netdata Agent, there is a consul-template process which manages the configuration for that particular Netdata Agent. Moreover, for every Netdata Agent, there is a Consul Agent that is accessible via `localhost`.

# Instructions

 - System: Ubuntu 18.04.4 LT
 - Scenario: Dynamically change the warning/critical levels for the `10min_cpu_usage` alarm of `health.d/cpu.conf`
 - Configuration for Consul-Template:
```
template {
  source = "<absolute_path>/template.ctmpl"
  destination = "/etc/netdata/health.d/cpu.conf"
  command = "systemctl restart netdata "
}
log_level = "debug"
```
**Comment:** The `command` attribute states what command should `consul-template` run after every change of the file. Depending on how you run Netdata, you may wish to modify this.


1. Install [Netdata Agent](https://learn.netdata.cloud/docs/agent/packaging/installer)
3. Install [Consul](https://www.consul.io/docs/install#install-consul)
4. Install [Consul-Template](https://github.com/hashicorp/consul-template)
5. Run consul in `dev` mode: `consul -dev`
6. Clone this repository
7. Navigate to navigate-community/configuration-management/consul
8. Change the `<absolute_path>` placeholder inside `configuration.hcl`
9. Populate the KV Store by running `consul KV put warning_value_low 10`
    1. Repeat this step for every variable you see in `template.ctmpl`
10. Run `sudo ./consul-template -config "./configuration.hcl"`
    1.  As per our [documentation](https://learn.netdata.cloud/guides/step-by-step/step-04), `sudo` is required to edit the Netdata configuration files.
11. Navigate to `localhost:19999` and see that the alarms variables for this alarm are not the default ones but are the ones we added in the `KV Store`
12. Change a value by running the same command as in step (8) but with a different value, observe that it propagates to the Netdata Agent.
13. Share your setup back with the Community by [making a PR](https://github.com/netdata/netdata-community/compare) and joining the discussion in the [Netdata Community](https://community.netdata.cloud/topic/162/configuration-management-with-consul).



