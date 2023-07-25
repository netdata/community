# Diskquota monitoring with Netdata

Monitors the defined quotas on one or more filesystems depending on configuration.
Without configuration the collector attempts to gather the quotas for the root filesystem.

## Requirements

- `repquota` executable
- Working sudoers configuration that allows the netdata user access to the `repquota` executable

## Charts

It produces following charts:

1. **Blocks**

    - `<user>_blocks_used`
    - `<user>_blocks_softlimit`
    - `<user>_blocks_hardlimit`

2. **Files**

    - `<user>_files_used`
    - `<user>_files_softlimit`
    - `<user>_files_hardlimit`

## Netdata Configuration

Edit the `python.d/diskquota.conf` configuration file using `edit-config` from the Netdata [config
directory](https://learn.netdata.cloud/docs/configure/nodes), which is typically at `/etc/netdata`.

```bash
cd /etc/netdata   # Replace this path with your Netdata config directory, if different
sudo ./edit-config python.d/diskquota.conf
```

Needs only `command` specifying the correct call to `repquota`.  The command must always include the option `--output=csv`.

### Example

```yaml
localhost:
  command: 'sudo repquota --output=csv /'
```
## Sudoers Configuration

Edit the sudoers file using `visudo`.  Specify `EDITOR=nano` if you don't know how to exit vim!

```bash
sudo EDITOR=nano visudo
```

The only required line is to allow restricted access to the repquota executable,
but it is also recommended to disable logging of allowed privilege escalations to prevent excessive logging.

### Example

```conf
netdata    ALL=(root)    NOPASSWD: /sbin/repquota --output=csv /
Defaults:netdata !log_allowed
```

---

