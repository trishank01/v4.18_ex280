#!/bin/bash
echo "=========================================================="
echo "  Setting up Q13: Inter-Project NetworkPolicy Scenario"
echo "=========================================================="

echo "[1/4] Preparing projects 'database' and 'checker'..."
oc new-project database &>/dev/null || true
oc new-project checker &>/dev/null || true

echo "[2/4] Labeling namespace 'checker' with 'team=devsecops'..."
oc label namespace checker team=devsecops --overwrite &>/dev/null || true

echo "[3/4] Deploying target database application in 'database' namespace..."
oc delete deployment mysql -n database &>/dev/null || true
oc delete svc mysql -n database &>/dev/null || true
oc delete netpol db-allow-mysql-conn -n database &>/dev/null || true

oc create deployment mysql --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n database &>/dev/null || true
oc patch deployment mysql -p '{"spec":{"template":{"metadata":{"labels":{"app":"mysql","network.openshift.io/policy-group":"database"}}}}}' -n database &>/dev/null || true
oc expose deployment mysql --port=3306 -n database &>/dev/null || true

echo "[4/4] Deploying client application 'web-mysql' in 'checker' namespace..."
oc delete deployment web-mysql -n checker &>/dev/null || true
oc create deployment web-mysql --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n checker &>/dev/null || true
oc patch deployment web-mysql -p '{"spec":{"template":{"metadata":{"labels":{"app":"web-mysql","deployment":"web-mysql"}}}}}' -n checker &>/dev/null || true

echo ""
echo ">>> Q13 Setup Complete!"
echo "  - In 'database': Pod has label 'network.openshift.io/policy-group=database', listening on port 3306"
echo "  - In 'checker':  Pod has label 'deployment=web-mysql', namespace has 'team=devsecops'"
echo "=========================================================="
