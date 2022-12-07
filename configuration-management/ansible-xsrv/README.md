# Deploy Netdata with Ansible

How to use [Ansible](https://en.wikipedia.org/wiki/Ansible_(software)) and the [xsrv.monitoring_netdata](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring_netdata) role to quickly deploy and configure the Netdata Agent on one or more remote nodes.

This document uses `my.CHANGEME.org` as example target hostname, and `deploy` as example administrative (`sudo`) user account - replace these values according to your environment.


## Requirements

Ansible runs on an administration machine (_controller_) and configures one or more remote servers (_hosts_), over the network using SSH.


### Setup hosts


The role is designed to run against [Debian](https://www.debian.org/) [Stable](https://wiki.debian.org/DebianStable) (Debian 11 "Bullseye") operating systems. Setup a [minimal Debian installation](https://xsrv.readthedocs.io/en/latest/appendices/debian.html) on the host, then:

```bash
# install ansible requirements
apt update && apt --no-install-recommends install python3 aptitude sudo openssh-server
# create an administrator user account (replace deploy with the desired name)
useradd --create-home --groups ssh,sudo --shell /bin/bash deploy
# set the sudo password for this user
passwd deploy
```


### Setup the ansible controller

A controller machine will be used for deployment and remote administration. The controller stores a YAML-based text description of your setup, and deploys it to remote hosts over SSH.

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-venv python3-pip python3-cryptography openssh-client
# generate a SSH key pair if not already done
ssh-keygen -b 4096
# authorize your SSH key on the remote user account
ssh-copy-id deploy@my.CHANGEME.org
```

[Install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). This example uses a single project directory containing an independent ansible installation ([virtualenv](https://docs.python.org/3/library/venv.html)) and all configuration files:

```bash
# create the project directory
mkdir ~/myproject
# create a virtualenv
python3 -m venv ~/myproject/.venv
source ~/myproject/.venv/bin/activate
# install ansible in a virtualenv
pip3 install ansible
# generate a random password to encrypt sensitive configuration values
openssl rand -base64 30 > ~/myproject/.ansible-vault-password
```

Inside the project directory, create the following files:

**~/myproject/ansible.cfg**

```ini
[defaults]
# default inventory file
inventory = inventory.yml
# pretty-print ansible output (see ansible-doc -t callback -l for available stdout_callbacks)
stdout_callback = ansible.posix.debug
# colon-separated paths in which Ansible will search for collections content
collections_paths = ./
# ansible-vault password file to use
vault_password_file = .ansible-vault-password
```

**~/myproject/inventory.yml**

```yaml
all:
  hosts:
    my.CHANGEME.org:
```

**~/myproject/playbook.yml**

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.monitoring_netdata
```

**~/myproject/host_vars/my.CHANGEME.org/my.CHANGEME.org.yml**

```yaml
# SSH host/port, if different from my.CHANGEME.org/22
# ansible_host: "1.2.3.4"
# ansible_port: 22
```

**~/myproject/host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml**

```yaml
# administrator (sudo) account username/password
ansible_user: "deploy"
ansible_become_pass: "CHANGEME"
```

**~/myproject/requirements.yml**

```yaml
collections:
  - name: https://gitlab.com/nodiscc/xsrv.git
    type: git
    version: release
```

Install the collection:

```bash
cd ~/myproject/
ansible-galaxy collection install --force -r requirements.yml
```

Encrypt the "vault" file containing sensitive configuration values:

```bash
ansible-vault encrypt host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
```

-------------------


If needed, add any changes to the default configuration, to your host's `host_vars` files. For example:

```yaml
# host_vars/my.CHANGEME.org.vault.yml
# SSH host/port, if different from my.CHANGEME.org/22
# ansible_host: "1.2.3.4"
# ansible_port: 22

# don't setup additional/custom netdata modules
setup_netdata_debsecan: no
setup_netdata_logcount: no
setup_needrestart: no
# set netdata charts update frequency
netdata_update_every: 5
# example http check
netdata_http_checks:
  - name: example.com
    url: https://example.com
    status_accepted:
      - 200
      - 401
    timeout: 10
    update_every: 20
```

See the [role defaults](https://github.com/nodiscc/xsrv/blob/master/roles/monitoring_netdata/defaults/main.yml) for all available configuration variables.


## Deploy

Once host variables are set, deploy the role to the remote host:

```bash
# activate the virtualenv if not already done
source .venv/bin/activate
# (optional) simulate changes (dry-run)
ansible-playbook --check playbook.yml
# deploy netdata/apply configuration
ansible-playbook playbook.yml
```

## Access netdata

Access your netdata dashboard at https://my.CHANGEME.org:19999

<!-- TODO screencast -->

## Configuration

At any time you can change configuration in `host_vars`:

```bash
# plain-text configuration values
$EDITOR host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
# encrypted configuration values
ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
```

After any change to your ansible project files, **run the playbook to apply changes**:

```bash
ansible-playbook playbook.yml
```

Other useful command-line flags such as `--diff` `--verbose ` and ansible.cfg configuration settings are available. See [ansible-plybook](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html) and [Ansible Configuration Settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)

If you need to apply the same configuration variables to multiple hosts, you may organize your hosts in [groups](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yaml_inventory.html), and use [`group_vars`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html) to configure mutiple hosts from a single configuration entry:

```yaml
# inventory.yml
all:
  children:
    staging:
      hosts:
        dev.CHANGEME.org
        dev-db.CHANGEME.org
        dev-proxy.CHANGEME.org
    prod:
      hosts:
        prod.CHANGEME.org
        prod-db.CHANGEME.org
        prod-proxy.CHANGEME.org
```

```yaml
# group_vars/all/main.yml
# enable netdata cloud features on all hosts
netdata_cloud_enabled: yes
```

```yaml
# group_vars/dev/main.yml
# we don't need that much chart data retention in our staging environment
netdata_dbengine_disk_space: 100
```

```yaml
# group_vars/prod/main.yml
# don't send alarm notifications between 23:00 and 06:00 in production
netdata_notification_downtimes:
  - start: "00 23 * * *"
    end: "00 06 * * *"
```

Apply the role on `all` hosts instead of a single host:

```yaml
# playbook.yml
- hosts: all
  roles:
    - nodiscc.xsrv.monitoring_netdata
```

You may also setup additional functionality (automatic upgrades) and integration with various services using other [xsrv roles](https://xsrv.readthedocs.io/en/latest/#roles), or write your [own roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) with netdata integration in mind.


## External links

- [User Guide - Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/index.html)
- [Intro to playbooks - Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)
- [Using variables - Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html)
- [xsrv - documentation](https://xsrv.readthedocs.io/en/latest/)
