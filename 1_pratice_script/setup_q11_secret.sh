#!/bin/bash
echo "=========================================================="
echo "  Setting up Q11: Secret Creation Scenario"
echo "=========================================================="
oc new-project math &>/dev/null || true
oc delete secret magic -n math &>/dev/null || true
echo ">>> Q11 Setup Complete: Ready to create secret 'magic'."
echo "=========================================================="
