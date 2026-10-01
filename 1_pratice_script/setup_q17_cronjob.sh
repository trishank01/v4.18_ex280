#!/bin/bash
echo ">>> Setting up Q17: Preparing lorem project..."
oc new-project lorem &>/dev/null || true
oc delete cronjob ipsum -n lorem &>/dev/null || true
echo ">>> Q17 Setup Complete: lorem project clean."
