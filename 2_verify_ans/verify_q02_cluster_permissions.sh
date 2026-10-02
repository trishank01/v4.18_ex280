#!/bin/bash
echo "=========================================================="
echo "  Verifying Q02: Cluster Permissions & Self-Provisioning"
echo "=========================================================="
S=0

# Check 1: User jobs has cluster-admin
if [ "$(oc auth can-i '*' '*' --as jobs 2>/dev/null)" = "yes" ] || \
   oc get clusterrolebinding -o json 2>/dev/null | grep -qE 'cluster-admin.*jobs|jobs.*cluster-admin'; then
  echo "  [PASS] User 'jobs' can perform cluster administration (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] User 'jobs' CANNOT perform cluster administration (0 pts)"
  echo "         --> Run: oc adm policy add-cluster-role-to-user cluster-admin jobs"
fi

# Check 2: User wozniak can create projects
if [ "$(oc auth can-i create projectrequests --as wozniak 2>/dev/null)" = "yes" ] || \
   oc get clusterrolebinding -o json 2>/dev/null | grep -qE 'self-provisioner.*wozniak|wozniak.*self-provisioner'; then
  echo "  [PASS] User 'wozniak' can create new projects (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] User 'wozniak' CANNOT create projects (0 pts)"
  echo "         --> Run: oc adm policy add-cluster-role-to-user self-provisioner wozniak"
fi

# Check 3: User wozniak cannot administer cluster
if [ "$(oc auth can-i '*' '*' --as wozniak 2>/dev/null)" = "no" ]; then
  echo "  [PASS] User 'wozniak' is restricted from cluster administration (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] User 'wozniak' has cluster-admin privileges (Should NOT have!) (0 pts)"
fi

# Check 4: User armstrong cannot create projects (self-provisioner removed from system:authenticated:oauth)
if [ "$(oc auth can-i create projectrequests --as armstrong --as-group system:authenticated:oauth 2>/dev/null)" = "no" ] || \
   [ "$(oc auth can-i create projectrequests --as armstrong 2>/dev/null)" = "no" ] || \
   ! oc get clusterrolebinding self-provisioners -o json 2>/dev/null | grep -q 'system:authenticated:oauth'; then
  echo "  [PASS] User 'armstrong' is blocked from creating projects (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] User 'armstrong' CAN still create projects (0 pts)"
  echo "         --> Run: oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth"
fi

echo ""
if ! oc get secret kubeadmin -n kube-system &>/dev/null; then
  echo "  [INFO] Kubeadmin secret is deleted (Satisfies exam removal condition)."
else
  echo "  [INFO] Kubeadmin secret still exists (Remember to delete at the very end of exam)."
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
