
LAN Setup Instructions
======================

This is valid for an on permise cloud infrastructure, so called LAN

Create your inventory file
---------------------------
You need two groups on your inventory: tag_env-host-type_{{ oo_env }}-openshift-master and 
tag_env-host-type_{{ oo_env }}-openshift-minions where oo_env value must be consistent accross your inventory.

Here is an example

```

# The oo_env should match the value between tag_env-host-type_{{ oo_env }}-openshift-minion

[all:vars]
oo_env=test-1a
oo_openshift_binary=/home/abenaissi/origin/_output/local/bin/linux/amd64/openshift

[all:children]
tag_env-host-type_test-1a-openshift-minion
tag_env-host-type_test-1a-openshift-master

[tag_env-host-type_test-1a-openshift-master]
openshift-master.company.net

[tag_env-host-type_test-1a-openshift-minion]
openshift-minion-01.company.net oo_minion_subnet_index=1
openshift-minion-02.company.net oo_minion_subnet_index=2
openshift-minion-03.company.net oo_minion_subnet_index=3

```

Test The Setup
--------------
1. cd openshift-online-ansible
1. Define the ansible filter_plugin directory
```
ANSIBLE_FILTER_PLUGINS=/home/abenaissi/openshift-online-ansible/filter_plugins
```

1. ATTENTION: You need ForwardAgent enabled on your ansible controller
The ansible on premise playbooks uses the synchronize module to copy 
Openshift master ceritificates from the master to the minions.
This module requires agent forwarding to be enable to avoid having to 
add the public key of the master to the authorized_keys of the minions.
In your $HOME/.ssh/config
```
ForwardAgent yes
```
many Unix distribution requires that the ssh-agent should be started:
```
eval `ssh-agent -s`
ssh-add
```

1. Launch the ansible playbooks manually
```
ansible-playbook playbooks/lan/openshift-master/launch.yml -e oo_env=test-1a
ansible-playbook playbooks/lan/openshift-minion/launch.yml -e oo_env=test-1a
```




