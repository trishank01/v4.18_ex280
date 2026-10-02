#!/bin/bash
echo "=========================================================="
echo "  Setting up Q14: Troubleshoot Failing Deployment"
echo "=========================================================="
oc new-project mercury &>/dev/null || true
oc delete deployment atlas -n mercury &>/dev/null || true
echo "[1/2] Deploying 'atlas' application..."
oc create deployment atlas --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n mercury &>/dev/null || true
echo "[2/2] Injecting 50Gi memory request (causing pod to hang in Pending)..."
oc patch deployment atlas -p '{"spec":{"template":{"spec":{"containers":[{"name":"hello-world-nginx","resources":{"requests":{"memory":"50Gi"}}}]}}}}' -n mercury &>/dev/null || true
echo ">>> Q14 Setup Complete: Pod 'atlas' is Pending due to excessive memory request. Fix it to 1Gi."
echo "=========================================================="
