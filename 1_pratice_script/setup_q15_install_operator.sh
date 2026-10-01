#!/bin/bash
echo ">>> Setting up Q15: Preparing openshift-file-integrity project..."
oc new-project openshift-file-integrity &>/dev/null || true
echo ">>> Q15 Setup Complete: Ready to install File Integrity Operator."
