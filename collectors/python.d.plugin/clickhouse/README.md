**Note**: Copied from here: https://github.com/FedericoCeratto/netdata/tree/plugin-clickhouse/collectors/python.d.plugin/clickhouse

# clickhouse

This module monitors the ClickHouse database server.

It produces metrics based of the following queries:
* "events" category: "SELECT event, value FROM system.events"
* "async" category: "SELECT metric, value FROM system.asynchronous_metrics"
* "metrics" category: "SELECT metric, value FROM system.metrics"

**Requirements:**
ClickHouse allowing access without username and password.

## installation

```bash
# download python script
sudo wget https://raw.githubusercontent.com/FedericoCeratto/netdata/plugin-clickhouse/collectors/python.d.plugin/clickhouse/clickhouse.chart.py -O /usr/libexec/netdata/python.d/clickhouse.chart.py

# download default conf
sudo wget https://raw.githubusercontent.com/FedericoCeratto/netdata/plugin-clickhouse/collectors/python.d.plugin/clickhouse/clickhouse.conf -O /etc/netdata/python.d/clickhouse.conf

# go to netdata dir
cd /etc/netdata

# enable collector by adding line a new line with "clickhouse: yes"
sudo ./edit-config python.d.conf

# restart netdata
sudo systemctl restart netdata

# become user netdata
sudo su -s /bin/bash netdata

# run in debug
/usr/libexec/netdata/plugins.d/python.d.plugin clickhouse debug trace nolock
```

## Configuration

See the comments in the default configuration file.