#!/bin/bash
echo "=========================================================="
echo "  Setting up Q03: Project Permissions Scenario"
echo "=========================================================="
for p in apollo manhattan gemini bluebook titan; do
  echo "  --> Initializing project '$p'..."
  oc new-project $p &>/dev/null || true
  oc adm policy remove-role-from-user admin armstrong -n $p &>/dev/null || true
  oc adm policy remove-role-from-user view wozniak -n $p &>/dev/null || true
done
echo ">>> Q03 Setup Complete: Projects created without rolebindings."
echo "=========================================================="
