#!/bin/bash
echo "=========================================================="
echo "  Setting up Q05: ResourceQuota Scenario"
echo "=========================================================="
echo "[1/2] Ensuring project 'manhattan' exists..."
oc new-project manhattan &>/dev/null || true
echo "[2/2] Removing existing quota 'ex280-quota'..."
oc delete resourcequota ex280-quota -n manhattan &>/dev/null || true
echo ">>> Q05 Setup Complete: Ready to configure quota."
echo "=========================================================="
