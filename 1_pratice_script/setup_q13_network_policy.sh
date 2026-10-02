#!/bin/bash
echo "=========================================================="
echo "  Setting up Q13: Inter-Project NetworkPolicy Scenario"
echo "=========================================================="
oc new-project database &>/dev/null || true
oc new-project checker &>/dev/null || true
echo "[1/3] Applying label 'team=devsecops' to namespace 'checker'..."
oc label namespace checker team=devsecops --overwrite &>/dev/null || true
echo "[2/3] Cleaning up old network policies..."
oc delete netpol db-allow-mysql-conn -n database &>/dev/null || true
echo "[3/3] Deploying 'web-mysql' app in 'checker'..."
oc delete deployment web-mysql -n checker &>/dev/null || true
oc create deployment web-mysql --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n checker &>/dev/null || true
echo ">>> Q13 Setup Complete: Database and Checker projects ready."
echo "=========================================================="
