#!/bin/bash
echo "=========================================================="
echo "  Setting up Q12: Use Secret in Deployment Scenario"
echo "=========================================================="
oc new-project math &>/dev/null || true
oc delete deployment red -n math &>/dev/null || true
oc create deployment red --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n math &>/dev/null || true
echo ">>> Q12 Setup Complete: Deployment 'red' ready without secret injected."
echo "=========================================================="
