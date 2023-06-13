# Ansible ML Demo

Ansible resources and playbooks used for configuration management of the nodes in the Netdata Demo [Machine Learning room](https://app.netdata.cloud/spaces/netdata-demo/rooms/machine-learning/overview) of the public [Netdata Demo space](https://app.netdata.cloud/spaces/netdata-demo). 

## Useful commands

```bash
# list hosts
ansible all -i inventory.yaml --list-hosts
```

```bash
# ping inventory
ansible all -i inventory.yaml -m ping
```

```bash
# ping beastvms inventory
ansible beastvms -m ping -i inventory.yaml
```

```bash
# run playbook
ansible-playbook -i inventory.yaml playbooks/main.yaml
```

```bash
# run playbook with become password
ansible-playbook -i inventory.yaml playbooks/main.yaml --ask-become-pass
```

```bash
# run individual task
ansible-playbook -i inventory.yaml tasks/install-logrotate.yaml --ask-become-pass
```
