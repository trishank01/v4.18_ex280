#!/bin/bash
echo "=========================================================="
echo "  Setting up Q09: Deploy App & Troubleshoot Service Selector"
echo "=========================================================="
oc new-project apples &>/dev/null || true
oc delete deployment oranges -n apples &>/dev/null || true
oc delete svc oranges -n apples &>/dev/null || true
oc delete route oranges -n apples &>/dev/null || true

echo "[1/2] Deploying application 'oranges'..."
oc create deployment oranges --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n apples &>/dev/null || true

echo "[2/2] Creating service 'oranges' with intentionally wrong selector and route..."
oc create service clusterip oranges --tcp=8080:8080 -n apples &>/dev/null || true
oc patch svc oranges -p '{"spec":{"selector":{"app":"wrong-label"}}}' -n apples &>/dev/null || true
oc expose svc oranges -n apples &>/dev/null || true

echo ">>> Q09 Setup Complete: Application 'oranges', Service, and Route ready in 'apples'."
echo "    Selector is broken. Fix it in 'oc edit svc oranges -n apples'."
echo "=========================================================="
