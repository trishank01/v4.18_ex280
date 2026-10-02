#!/bin/bash
echo "=========================================================="
echo "  Setting up Q08: ServiceAccount & SCC Scenario"
echo "=========================================================="
echo "[1/2] Preparing project 'apples'..."
oc new-project apples &>/dev/null || true
echo "[2/2] Resetting SA 'ex280sa' and SCC bindings..."
oc delete sa ex280sa -n apples &>/dev/null || true
oc adm policy remove-scc-from-user anyuid -z ex280sa -n apples &>/dev/null || true
echo ">>> Q08 Setup Complete: Ready to create ServiceAccount and assign SCC."
echo "=========================================================="
