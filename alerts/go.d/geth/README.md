---
title: Geth Alarms
date: 2021-08-09
tags: [go.d, alerts]
social_image: '/media/netdata-logomark.png'
description: Alerts for the Geth(Go-Ethereum) collector
---

# Geth Alerts

A community-curated collection of alerts for the [Geth collector](https://learn.netdata.cloud/docs/agent/collectors/go.d.plugin/modules/geth).


```
#chainhead_header is expected momenterarily to be ahead. If its considerably ahead (e.g more than 5 blocks), then the node is definetely out of sync.
 template: geth_chainhead_diff_between_header_block
       on: geth.chainhead
    class: Workload
     type: ethereum_node
component: geth
    every: 10s
     calc: $chain_head_block -  $chain_head_header
    units: blocks
     warn: $this != 0
     crit: $this > 5
    delay: up 5s
```
