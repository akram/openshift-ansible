
LAN Setup Instructions
======================

This is valid for an on permise cloud infrastructure, so called LAN

Put the IPs of your machines in the config file

```
cp config.sample config
```

Then, edit the `config` file with the following parameters:

```
# Mandatory to deploy OpenShift on pre-existing machines
export OO_PROVIDER=lan

# Specify the location of the OpenShift binary you want to deploy
export OO_OPENSHIFT_BINARY=$HOME/…/origin/_output/local/go/bin/openshift

# MASTERS and MINIONS must contain the comma-separated list of IPs of the machines
# where you want to deploy the master and the minions.
export MASTERS=192.168.122.249
export MINIONS=192.168.122.108,192.168.122.132
```

You can know deploy OpenShift on your machines with:
```
./cluster.sh create test
```
