# S.M.A.R.T metrics windows collector

This installer enables Netdata to collect basic windows metrics (Using windows_exporter which is packaged as part of the MSI) and S.M.A.R.T metrics from windows machines. Depending on the make, manufacturer and protocol used by the disks the metrics collected may vary.

## Pre-requisites
- Install smartmontools (you can find the download link [here](https://www.smartmontools.org/wiki/Download#InstalltheWindowspackage).)

## Installation
- Download the [Netdata.msi](https://github.com/netdata/community/blob/main/collectors/windows/S.M.A.R.T/Netdata.msi)
- Run the installation
- Verify that metrics are being collected by visiting localhost:19997/metrics

## Configuration

- On the Netdata Cloud UI, click on the gear icon next to the node you want to configure in the Nodes tab
- Search for `prometheus` and click on the `+` to add a new job
- In the window that opens fill in the following information
  - Configuration name (Eg: SmartD)
  - URL (Eg: 10.123.123.1:19997/metrics)
  - Application (Eg: SMART) 
- Click test to test the configuration and save to save and apply it.
- If the configuration was successful you should now see the metrics (If there were errors, you will see the error log)

This completes the installation and configuration, you should see the charts on your Netdata Cloud UI (app.netdata.cloud).
