#!/bin/bash
echo "=========================================================="
echo "  Setting up Q02: Cluster Permissions Scenario"
echo "=========================================================="
echo "[1/3] Removing cluster-admin from user 'jobs'..."
oc adm policy remove-cluster-role-from-user cluster-admin jobs &>/dev/null
echo "[2/3] Removing self-provisioner from user 'wozniak'..."
oc adm policy remove-cluster-role-from-user self-provisioner wozniak &>/dev/null
echo "[3/3] Restoring self-provisioner to global OAuth group..."
oc adm policy add-cluster-role-to-group self-provisioner system:authenticated:oauth &>/dev/null
echo ">>> Q02 Setup Complete: Permissions reset to default."
echo "=========================================================="
