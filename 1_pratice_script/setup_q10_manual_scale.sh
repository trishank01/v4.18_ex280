#!/bin/bash
echo "=========================================================="
echo "  Setting up Q10: Manual Scaling Scenario"
echo "=========================================================="
oc new-project lerna &>/dev/null || true
oc delete deployment hydra -n lerna &>/dev/null || true
echo "  --> Deploying 'hydra' with 1 replica..."
oc create deployment hydra --image=quay.io/redhattraining/hello-world-nginx:v1.0 --replicas=1 -n lerna &>/dev/null || true
echo ">>> Q10 Setup Complete: Scale hydra to 5 replicas."
echo "=========================================================="
