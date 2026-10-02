#!/bin/bash
echo ">>> Setting up Q06: Deploying oxcart in area51..."
oc new-project area51 &>/dev/null || true
oc delete deployment oxcart -n area51 &>/dev/null || true
oc delete svc oxcart -n area51 &>/dev/null || true
oc delete route oxcart -n area51 &>/dev/null || true
oc create deployment oxcart --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n area51 &>/dev/null || true
oc expose deployment oxcart --port=8080 -n area51 &>/dev/null || true
echo ">>> Q06 Setup Complete: Unsecured oxcart app deployed in area51."
