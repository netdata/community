# Collectors

Community contributed and maintained collectors live in here.

## Installation

If you would like to install a collector from the netdata/community repo please follow the instructions below. 

In general the below steps should be sufficient to use a third party collector.

1. Download collector code file into [folder expected by Netdata](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables).
2. Download default collector configuration file into [folder expected by Netdata](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables).
3. [Edit configuration file](https://github.com/netdata/netdata/blob/master/docs/collect/enable-configure.md#configure-a-collector) from step 2 if required.
4. [Enable collector](https://github.com/netdata/netdata/blob/master/docs/collect/enable-configure.md#enable-a-collector-or-its-orchestrator).
5. [Restart Netdata](https://github.com/netdata/netdata/blob/master/docs/configure/start-stop-restart.md) 

For example below are the steps to enable the [Python ClickHouse collector](/collectors/python.d.plugin/clickhouse/).

```bash
# download python collector script to /usr/libexec/netdata/python.d/
$ sudo wget https://raw.githubusercontent.com/netdata/community/main/collectors/python.d.plugin/clickhouse/clickhouse.chart.py -O /usr/libexec/netdata/python.d/clickhouse.chart.py

# (optional) download default .conf to /etc/netdata/python.d/
$ sudo wget https://raw.githubusercontent.com/netdata/community/main/collectors/python.d.plugin/clickhouse/clickhouse.conf -O /etc/netdata/python.d/clickhouse.conf

# enable collector by adding line a new line with "clickhouse: yes" to /etc/netdata/python.d.conf file
# this will append to the file if it already exists or create it if not
$ sudo echo "clickhouse: yes" >> /etc/netdata/python.d.conf

# (optional) edit clickhouse.conf if needed
$ sudo vi /etc/netdata/python.d/clickhouse.conf

# restart netdata 
# see docs for more information: https://learn.netdata.cloud/docs/configure/start-stop-restart
$ sudo systemctl restart netdata
```

Alternatively you can use [this helper script](/utilities/install-collector.sh) to automate the above steps.

```bash
# download and install the clickhouse collector
sudo wget -O /tmp/install-collector.sh https://raw.githubusercontent.com/netdata/community/main/utilities/install-collector.sh && sudo bash /tmp/install-collector.sh python.d.plugin/clickhouse
```