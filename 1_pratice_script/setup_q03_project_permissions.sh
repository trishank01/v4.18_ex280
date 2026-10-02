#!/bin/bash
echo ">>> Setting up Q03: Preparing Projects..."
for p in apollo manhattan gemini bluebook titan; do
  oc new-project $p &>/dev/null || true
  oc adm policy remove-role-from-user admin armstrong -n $p &>/dev/null || true
  oc adm policy remove-role-from-user view wozniak -n $p &>/dev/null || true
done
echo ">>> Q03 Setup Complete: Projects created without rolebindings."
