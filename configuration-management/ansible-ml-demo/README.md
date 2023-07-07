# Ansible ML Demo

Ansible resources and playbooks used for configuration management of the nodes in the Netdata Demo [Machine Learning room](https://app.netdata.cloud/spaces/netdata-demo/rooms/machine-learning/overview) of the public [Netdata Demo space](https://app.netdata.cloud/spaces/netdata-demo).

## Contents

Below are the various folders in this project and a brief description of what they contain.

- [`host_vars`](host_vars/) - some yaml files for host specific variables live in here.
- [`playbooks`](playbooks/) - various playbooks (collections of tasks) for common maintenance and configuration management activities.
- [`tasks`](tasks/) - yaml files defining low level tasks, related tasks group in folders (e.g. Netdata tasks live in [`tasks/netdata`](tasks/netdata/)).
- [`templates`](templates/) - templated files, typically configuration files live in here (all use [Jinja2](https://jinja.palletsprojects.com/)).
- [`vars`](vars/) - different variable files for each system or component live in here. Used by templates and tasks.
- [`inventory.yaml`](inventory.yaml) - A list of all the hosts managed by this Ansible project as well as one or two global default variables.

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
