#!/bin/bash
echo ">>> Setting up Q11: Preparing math project..."
oc new-project math &>/dev/null || true
oc delete secret magic -n math &>/dev/null || true
echo ">>> Q11 Setup Complete: Ready to create secret."
