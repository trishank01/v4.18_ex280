#!/bin/bash
echo ">>> Verifying Q01: HTPasswd Identity Provider..."
S=0
oc get secret ex280-idp-secret -n openshift-config &>/dev/null && S=$((S+20))
oc get oauth cluster -o json 2>/dev/null | grep -q 'ex280-htpasswd' && S=$((S+20))
for u in armstrong:indiaco collins:verastar aldrin:moonhar jobs:eastiver wozniak:glimpse; do
  user=${u%%:*}
  pass=${u##*:}
  (oc login -u $user -p $pass https://api.ocp4.example.com:6443 &>/dev/null || oc login -u $user -p ${user}123 https://api.ocp4.example.com:6443 &>/dev/null) && S=$((S+12))
done
oc login -u kubeadmin -p admin https://api.ocp4.example.com:6443 &>/dev/null || true
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
