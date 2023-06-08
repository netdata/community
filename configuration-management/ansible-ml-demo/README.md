# Ansible ML Demo

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

# run playbook with become password
ansible-playbook -i inventory.yaml playbooks/main.yaml --ask-become-pass
```
