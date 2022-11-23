<!--
title: "Speedtest monitoring with Netdata"
custom_edit_url: https://github.com/netdata/netdata/edit/master/collectors/charts.d.plugin/speedtest/README.md
sidebar_label: "Speedtest"
-->

# Speedtest monitoring with Netdata

[Speedtest CLI](https://www.speedtest.net/apps/cli) is a Linux native command line tool used to monitor internet connection performance. 

This module monitors results and metrics related to [Speedtest](https://www.speedtest.net/apps/cli).

## Requirements

For all nodes you are going to monitor speedtest results from:
- Install Speedtest CLI by following the installation instructions mentioned [here](https://www.speedtest.net/apps/cli).
- Accept the license agreement as the Netdata by running `speedtest` from the command line

```bash
sudo -u netdata speedtest
```

## Installation

This is a community maintained collector and not available as part of the Netdata agent by default. To install this collector follow these steps:

1. Download the [install-collector](https://github.com/netdata/community/blob/main/utilities/install-collector.sh) script to /etc/netdata (or wherever your netdata home happens to be)
```bash
wget https://github.com/netdata/community/blob/main/utilities/install-collector.sh
```
2. Give the script execute permission
```bash
chmod +x install-collector.sh
```
3. Run the script
```bash
sudo ./install-collector.sh charts.d.plugin/speedtest
```

## Metrics

All metrics have "speedtest." prefix.

| Metric              |    Scope    |  Dimensions   |     Units     |
|---------------------|:-----------:|:-------------:|:-------------:|
| download_speed      |   global    |  download     |  kilobits/s   |
| upload_speed        |   global    |  upload       |  kilobits/s   |
| packet_loss         |   global    |  loss         |  packets      |
| idle_latency        |   global    |  latency      |  milliseconds |
| download_latency    |   global    |  latency      |  milliseconds |
| upload_latency      |   global    |  latency      |  milliseconds |
| idle_jitter         |   global    |  jitter       |  milliseconds |
| download_jitter     |   global    |  jitter       |  milliseconds |
| upload_jitter       |   global    |  jitter       |  milliseconds |
| download_bytes      |   global    |  download     |  bytes        |
| upload_bytes        |   global    |  upload       |  bytes        |

## Configuration

Edit the `charts.d/speedtest.conf` configuration file using `edit-config` from the Netdata [config
directory](/docs/configure/nodes.md), which is typically at `/etc/netdata`.

```bash
cd /etc/netdata   # Replace this path with your Netdata config directory, if different
sudo ./edit-config charts.d/speedtest.conf
```

For all available options please see
module [configuration file](https://github.com/netdata/community/blob/main/collectors/charts.d.plugin/speedtest.conf).

## Troubleshooting

To troubleshoot issues with the `speedtest` collector, run the `charts.d.plugin` with the debug option enabled. The output
should give you clues as to why the collector isn't working.

- Navigate to the `plugins.d` directory, usually at `/usr/libexec/netdata/plugins.d/`. If that's not the case on
  your system, open `netdata.conf` and look for the `plugins` setting under `[directories]`.

  ```bash
  cd /usr/libexec/netdata/plugins.d/
  ```

- Switch to the `netdata` user.

  ```bash
  sudo -u netdata -s
  ```

- Run the `charts.d.plugin` to debug the collector:

  ```bash
  ./charts.d.plugin speedtest
  ```
