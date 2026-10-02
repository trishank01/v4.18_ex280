#!/bin/bash
echo ">>> Setting up Q12: Deploying red app in math without secret..."
oc new-project math &>/dev/null || true
oc delete deployment red -n math &>/dev/null || true
oc create deployment red --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n math &>/dev/null || true
echo ">>> Q12 Setup Complete: red app deployed without secret."
