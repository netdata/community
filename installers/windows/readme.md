# Netdata windows installation 

## Netdata MSI

This MSI installs and runs as a service the following:
- windows exporter (required for collecting metrics and converting them to OpenMetrics format)
- Netdata system information collector (required for collecting system information required for representing this Windows node uniquely as a virtual node on Netdata)
  
## Configure-windows.sh

This script should be copied to your Netdata configuration directory (/etc/netdata in most systems, but might also be /opt/netdata/etc/netdata in some)

And then run as follows:

sudo ./configure-windows.sh <IP or Hostname or DNS name of Windows system to be monitored> 

A list of entries in a file can also be provided as input for automating the configuration of a large number of Windows hosts.
