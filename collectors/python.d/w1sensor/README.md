---
title: 1-Wire Sensors collector
date: 2021-01-03
tags: [collector, python.d]
social_image: '/media/w1sensor.png'
description: A collector that monitors sensor temperatures
---

# 1-Wire Sensors monitoring with Netdata

Monitors sensor temperature.

On Linux these are supported by the wire, w1_gpio, and w1_therm modules.
Currently temperature sensors are supported and automatically detected.

Charts are created dynamically based on the number of detected sensors.

## Configuration

Edit the `python.d/w1sensor.conf` configuration file using `edit-config` from the Netdata [config
directory](/docs/configure/nodes.md), which is typically at `/etc/netdata`.

```bash
cd /etc/netdata   # Replace this path with your Netdata config directory, if different
sudo ./edit-config python.d/w1sensor.conf
```

---

