#!/bin/bash
echo "=========================================================="
echo "  Setting up Q06: Secure Edge Route Scenario"
echo "=========================================================="
echo "[1/3] Preparing project 'area51'..."
oc new-project area51 &>/dev/null || true
echo "[2/3] Cleaning up existing oxcart resources..."
oc delete deployment oxcart -n area51 &>/dev/null || true
oc delete svc oxcart -n area51 &>/dev/null || true
oc delete route oxcart -n area51 &>/dev/null || true
echo "[3/3] Deploying base HTTP application 'oxcart'..."
oc create deployment oxcart --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n area51 &>/dev/null || true
oc expose deployment oxcart --port=8080 -n area51 &>/dev/null || true
echo ">>> Q06 Setup Complete: Application 'oxcart' deployed with plain HTTP."
echo "=========================================================="
