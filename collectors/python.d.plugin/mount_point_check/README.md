# Mount Point Availability Monitoring with Netdata

Monitors mount point availability.

Following charts are drawn per host:

1. **Status** boolean

    - 1 if directory exists and is a mount point. 0 otherwise.

## Configuration

Edit the `python.d/mount_point_check.conf` configuration file using `edit-config` from the Netdata [config
directory](https://learn.netdata.cloud/docs/configure/nodes), which is typically at `/etc/netdata`.

```bash
cd /etc/netdata   # Replace this path with your Netdata config directory, if different
sudo ./edit-config python.d/mount_point_check.conf
```

```yaml
jobs:
  - name: _mnt_shared_blob_                 # [required] my job name
    path: "/mnt/shared/blob/"               # [required] path to the mount point

  - name: _var_lib_netdata_testmount_       # job name of second job
    path: "/var/lib/netdata/testmount/"     # path to another mount point
```

## Alarms

Edit the `health.d/mount_point_check.conf` configuration file using `edit-config` from the Netdata [config
directory](https://learn.netdata.cloud/docs/configure/nodes), which is typically at `/etc/netdata`. The following
example will send a critical alert as soon as one of the configured mount points is missing:

```yaml
 template: mount_point_missing
       on: mountpointcheck.status
    class: Errors
     type: Other
   lookup: max -1s of available
    every: 10s
    units: boolean
     crit: $this <= 0
  summary: Check whether the expected mount point is available.
       to: sysadmin
```

### Notes

- Filesystem permissions might block Netdata's access to the provided path in the configuration file. In this case the
  state will be reported as 0.

---


