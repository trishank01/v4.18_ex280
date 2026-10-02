#!/bin/bash
echo ">>> Setting up Q10: Deploying hydra in lerna..."
oc new-project lerna &>/dev/null || true
oc delete deployment hydra -n lerna &>/dev/null || true
oc create deployment hydra --image=quay.io/redhattraining/hello-world-nginx:v1.0 --replicas=1 -n lerna &>/dev/null || true
echo ">>> Q10 Setup Complete: hydra running with 1 replica."
