# Netdata Ansible Quickstart

This ansible playbook installs, configures, and claims Netdata agents to Netdata Cloud.

## Usage

1. **Configure inventory**: Edit `hosts` file with your target servers
2. **Set variables**: Update `vars/main.yml` with your Netdata Cloud credentials
3. **Run playbook**: Execute the main playbook

```bash
ansible-playbook -i hosts playbook.yml
```

## Configuration

### Required Variables (vars/main.yml)
- `claim_token`: Your Netdata Cloud claim token
- `claim_rooms`: Your Netdata Cloud room ID
- `claim_url`: Netdata Cloud URL (default: https://app.netdata.cloud)

### Optional Variables
- `reclaim`: Force re-claiming of nodes (default: false)
- `dbengine_multihost_disk_space`: Database size in MiB (default: 2048)
- `web_mode`: Agent web server mode (default: none)

## Tasks Performed

1. **Install**: Downloads and installs Netdata using the official kickstart script
2. **Configure**: Applies custom configuration template
3. **Claim**: Claims the node to Netdata Cloud (or re-claims if specified)

## Documentation

For additional installation methods and detailed documentation, see:
https://github.com/netdata/netdata/tree/master/packaging/installer/methods/ansible.md
