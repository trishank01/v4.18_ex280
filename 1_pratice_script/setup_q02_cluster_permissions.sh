#!/bin/bash
echo ">>> Setting up Q02: Resetting Cluster Permissions..."
oc adm policy remove-cluster-role-from-user cluster-admin jobs &>/dev/null
oc adm policy remove-cluster-role-from-user self-provisioner wozniak &>/dev/null
oc adm policy add-cluster-role-to-group self-provisioner system:authenticated:oauth &>/dev/null
echo ">>> Q02 Setup Complete: Standard permissions restored."
