---
title: nsd collector
date: 2021-01-03
tags: [collector, python.d]
social_image: '/media/netdata-logomark.png'
description: A collector for NSD monitoring.
---

# NSD monitoring with Netdata

Uses the `nsd-control stats_noreset` command to provide `nsd` statistics.

## Requirements

-   Version of `nsd` must be 4.0+
-   Netdata must have permissions to run `nsd-control stats_noreset`

It produces:

1.  **Queries**

    -   queries

2.  **Zones**

    -   master
    -   slave

3.  **Protocol**

    -   udp
    -   udp6
    -   tcp
    -   tcp6

4.  **Query Type**

    -   A
    -   NS
    -   CNAME
    -   SOA
    -   PTR
    -   HINFO
    -   MX
    -   NAPTR
    -   TXT
    -   AAAA
    -   SRV
    -   ANY

5.  **Transfer**

    -   NOTIFY
    -   AXFR

6.  **Return Code**

    -   NOERROR
    -   FORMERR
    -   SERVFAIL
    -   NXDOMAIN
    -   NOTIMP
    -   REFUSED
    -   YXDOMAIN

Configuration is not needed.

---

