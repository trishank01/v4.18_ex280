#!/bin/bash
echo ">>> Verifying Q02: Cluster Permissions & Self-Provisioning..."
S=0
[ "$(oc auth can-i '*' '*' --as jobs 2>/dev/null)" = "yes" ] && S=$((S+25))
[ "$(oc auth can-i create projectrequests --as wozniak 2>/dev/null)" = "yes" ] && S=$((S+25))
[ "$(oc auth can-i '*' '*' --as wozniak 2>/dev/null)" = "no" ] && S=$((S+25))
[ "$(oc auth can-i create projectrequests --as armstrong 2>/dev/null)" = "no" ] && S=$((S+25))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
if ! oc get secret kubeadmin -n kube-system &>/dev/null; then
  echo "ℹ️ Note: Kubeadmin secret is deleted (Satisfies exam removal requirement)."
fi
