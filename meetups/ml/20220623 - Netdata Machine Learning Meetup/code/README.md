# Code

This code sets up and configures the below nodes:

- `ml-demo-parent`: A parent netdata node the others stream to and runs ML for the `*ml-disabled*` nodes.
- `ml-demo-ml-enabled`: A node with ML enabled that streams to `ml-demo-parent`.
- `ml-demo-ml-disabled`: A node with ML disabled that streams to `ml-demo-parent` where the parent will do the ML for this node.
- `ml-demo-ml-enabled-orphan`: A node with ML enabled that has no parent.
- `ml-demo-ml-disabled-orphan`: A node with ML disabled that has no parent.
- `ml-demo-ml-enabled-meetup`: A node with ML enabled that streams to `ml-demo-parent`. This is the one we will play around with.

**Note**: any sensitive variables or things you would need to re-create have been replaced with the string "XXX".

- `gcp-compute-instances-ml-demo.tf`: Example terraform script to create the VM's used in the demo.
- `scripts/startup-ml-demo.sh`: Startup script for the VM's to do some config.
- `scripts/finish-ml-demo.sh`: Final script to run after startup script for the VM's to do some more config.

Yes there is a lot of copy paste going on in here in my scripts - i need to learn Ansible :) 