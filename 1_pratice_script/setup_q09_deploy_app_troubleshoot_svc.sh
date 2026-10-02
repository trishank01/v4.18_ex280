#!/bin/bash
echo ">>> Setting up Q09: Deploying oranges with broken service selector..."
oc new-project apples &>/dev/null || true
oc delete deployment oranges -n apples &>/dev/null || true
oc delete svc oranges -n apples &>/dev/null || true
oc create deployment oranges --image=quay.io/redhattraining/hello-world-nginx:v1.0 -n apples &>/dev/null || true
oc create service clusterip oranges --tcp=8080:8080 -n apples &>/dev/null || true
oc patch svc oranges -p '{"spec":{"selector":{"app":"wrong-label"}}}' -n apples &>/dev/null || true
echo ">>> Q09 Setup Complete: oranges app running with unmapped service selector."
