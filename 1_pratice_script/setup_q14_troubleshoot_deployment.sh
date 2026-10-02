#!/bin/bash
echo ">>> Setting up Q14: Deploying failing atlas app in mercury..."
oc new-project mercury &>/dev/null || true
oc delete deployment atlas -n mercury &>/dev/null || true
oc create deployment atlas --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n mercury &>/dev/null || true
oc patch deployment atlas -p '{"spec":{"template":{"spec":{"containers":[{"name":"hello-world-nginx","resources":{"requests":{"memory":"50Gi"}}}]}}}}' -n mercury &>/dev/null || true
echo ">>> Q14 Setup Complete: atlas app deployed with pending pod (insufficient memory)."
