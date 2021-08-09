## Intro

Netdata alerts are a critical piece of what makes Netdata so easy to use. It comes packaged with a large number of alerts about common use-cases, ready to be used with sane defaults. That makes Netdata to work out-of-the-box for most applications.

There are times though, that users create more advanced alerts about certain niche use-cases.

This directory is the home of all alerts that have been contributed by users, but are not added to the main  [netdata/netdata repository](https://github.com/netdata/netdata).


## How to install an alert

To install a collector, you need to either visit the Netdata Marketplace (WIP) or visit the respective README inside the `alerts` directory.

The alert directory is structured in the same manner as the `/collectors`.

`/alerts/<collector_plugin>/<collector>/`

Inside every directory, there is a single `README.md` that has all the community-contributed alert definitions. So for example, if you want to add a community alert for geth, you will edit the following README:
`/alerts/go.d/geth/README.md`.

To install an alert, you first have to find the alert definition inside the README file of the respective collector.

An alert definition looks like this:

```
template: 10min_cpu_usage
      on: system.cpu
      os: linux
   hosts: *
  lookup: average -10m unaligned of user,system,softirq,irq,guest
   units: %
   every: 1m
    warn: $this > (($status >= $WARNING)  ? (75) : (85))
    crit: $this > (($status == $CRITICAL) ? (85) : (95))
   delay: down 15m multiplier 1.5 max 1h
    info: average cpu utilization for the last 10 minutes (excluding iowait, nice and steal)
      to: sysadmin
```

Aftewards:

1. Locate the directory where Netdata stores it's configuration. For example: `/etc/netdata/`.
2. Run `sudo /etc/netdata/edit-config health.d/<collector_name>. It will open a text editor, showing the default alerts that are already enabled for this data source.
3. Paste the alert definition you copied from the README file
4. Close the file
5. Restart Netdata (e.g `systemctl restart netdata) or run `netdatacli reload-health1` or `killall -USR2 netdata`.

## How to contribute an alert

Contributing a communtiy alert is very easy.

All alerts should be grouped by data source and be placed inside the `README.md` of that data source. If the data source does not exist, create a directory structure as follows:

`/alerts/<plugin>/<data_source>/README.md

For a list of data sources and plugins, you can visit the following page on our documentation: [How Netdata's metrics collectors work](https://learn.netdata.cloud/docs/collect/how-collectors-work).


## Additional Resources

- [Configure health alarms](https://learn.netdata.cloud/docs/monitor/configure-alarms)
- [Health configuration reference](https://learn.netdata.cloud/docs/agent/health/reference)
- [Creating your first health alarm in Netdata](https://www.youtube.com/watch?v=aWYj9VT8I5A)



