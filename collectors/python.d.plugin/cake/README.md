# Common Applications Kept Enhanced (CAKE) monitoring with Netdata

Monitors statistics produced by the CAKE qdisc.

Following charts are drawn:

1. Bandwidth
2. Packets
3. Memory

Following charts are drawn per CAKE tin:

1. Bandwidth
2. Packets
3. Delay
4. Flows
5. Way

## Configuration

Edit the `python.d/cake.conf` configuration file using `edit-config` from the Netdata [config
directory](https://learn.netdata.cloud/docs/configure/nodes), which is typically at `/etc/netdata`.

```bash
cd /etc/netdata   # Replace this path with your Netdata config directory, if different
sudo ./edit-config python.d/cake.conf
```

Here is an example for 2 interfaces:

```yaml
interfaces: [lan, wan]
tc_executable: /sbin/tc
```

`tc_executable` defaults to `/sbin/tc`.

---
