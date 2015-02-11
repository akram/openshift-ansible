
LAN Setup Instructions
======================

This is valid for an on permise cloud infrastructure, so called LAN

Create yourt inventory file
---------------------------
You need two groups on your inventory: masters and minions.
Here is an example

```
[all:vars]
oo_env=test-1a
oo_openshift_binary=/home/abenaissi/origin/_output/local/bin/linux/amd64/openshift

[all:children]
masters
minions

[masters]
openshift-master.company.net

[minions]
openshift-minion-01.company.net
openshift-minion-02.company.net
openshift-minion-03.company.net

```

Test The Setup
--------------
1. cd openshift-online-ansible
1. Define the ansible filter_plugin directory
```
ANSIBLE_FILTER_PLUGINS=/home/abenaissi/openshift-online-ansible/filter_plugins
```

1. Launch the ansible playbooks manually
```
ansible-playbook playbooks/lan/openshift-master/launch.yml -e oo_env=test-1a
ansible-playbook playbooks/lan/openshift-minion/launch.yml -e oo_env=test-1a
```




