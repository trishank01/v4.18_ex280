#!/bin/bash
echo ">>> Setting up Q13: Preparing database and checker projects..."
oc new-project database &>/dev/null || true
oc new-project checker &>/dev/null || true
oc label namespace checker team=devsecops --overwrite &>/dev/null || true
oc delete netpol db-allow-mysql-conn -n database &>/dev/null || true
oc delete deployment web-mysql -n checker &>/dev/null || true
oc create deployment web-mysql --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n checker &>/dev/null || true
echo ">>> Q13 Setup Complete: Database and Checker projects ready."
