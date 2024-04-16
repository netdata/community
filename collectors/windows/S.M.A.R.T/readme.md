# S.M.A.R.T metrics windows collector

This installer enables Netdata to collect basic windows metrics (Using windows_exporter which is packaged as part of the MSI) and S.M.A.R.T metrics from windows machines. Depending on the make, manufacturer and protocol used by the disks the metrics collected may vary.

## Pre-requisites
- Install smartmontools (you can find the download link [here](https://www.smartmontools.org/wiki/Download#InstalltheWindowspackage).)

## Installation
- Download the [Netdata.msi](https://github.com/netdata/community/blob/main/collectors/windows/S.M.A.R.T/Netdata.msi)
- Run the installation
- Verify that metrics are being collected by visiting localhost:19997/metrics

## Configuration
- Download the [configure-windows.sh](https://github.com/netdata/community/blob/main/collectors/windows/S.M.A.R.T/configure-windows.sh) script and copy it to your netdata directory (usually /etc/netdata or /opt/netdata/etc/netdata)
- Run the script
```sudo ./configure-windows.sh <IP or Hostname or DNS name of Windows server>```
- You can also provide a list of IPs (or Hostnames) in a file as input to configure multiple windows machines in one go.

This completes the installation and configuration, you should see the charts on your Netdata Cloud UI (app.netdata.cloud).
