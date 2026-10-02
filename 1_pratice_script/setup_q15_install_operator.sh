#!/bin/bash
echo "=========================================================="
echo "  Setting up Q15: Install Operator Scenario"
echo "=========================================================="
echo "  --> Preparing project 'openshift-file-integrity'..."
oc new-project openshift-file-integrity &>/dev/null || true
echo ">>> Q15 Setup Complete: Ready to install File Integrity Operator via Console or CLI."
echo "=========================================================="
