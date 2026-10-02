#!/bin/bash
echo ">>> Setting up Q05: Preparing Project manhattan..."
oc new-project manhattan &>/dev/null || true
oc delete resourcequota ex280-quota -n manhattan &>/dev/null || true
echo ">>> Q05 Setup Complete: Ready to configure quota."
