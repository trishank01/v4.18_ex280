#!/bin/bash
echo ">>> Setting up Q08: Preparing apples project..."
oc new-project apples &>/dev/null || true
oc delete sa ex280sa -n apples &>/dev/null || true
oc adm policy remove-scc-from-user anyuid -z ex280sa -n apples &>/dev/null || true
echo ">>> Q08 Setup Complete: apples project ready."
