#!/bin/bash
echo "=========================================================="
echo "  Setting up Q14: Troubleshoot Failing Deployment"
echo "=========================================================="
oc new-project mercury &>/dev/null || true
oc delete deployment atlas -n mercury &>/dev/null || true
oc delete svc atlas -n mercury &>/dev/null || true
oc delete route atlas -n mercury &>/dev/null || true

echo "[1/3] Deploying 'atlas' application..."
oc create deployment atlas --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n mercury &>/dev/null || true
oc expose deployment atlas --port=8080 -n mercury &>/dev/null || true
oc expose svc atlas -n mercury &>/dev/null || true

echo "[2/3] Injecting 50Gi memory request (causing pod to hang in Pending)..."
oc patch deployment atlas -p '{"spec":{"template":{"spec":{"containers":[{"name":"hello-world-nginx","resources":{"requests":{"memory":"50Gi"}}}]}}}}' -n mercury &>/dev/null || true

echo "[3/3] Ready!"
echo ">>> Q14 Setup Complete: Pod 'atlas' is Pending due to excessive memory request. Fix requests.memory to 1Gi."
echo "=========================================================="
