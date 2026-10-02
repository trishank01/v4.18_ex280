#!/bin/bash
echo "=========================================================="
echo "  Verifying Q08: ServiceAccount & anyuid SCC"
echo "=========================================================="
S=0

# Check 1: SA exists in apples
if oc get sa ex280sa -n apples &>/dev/null; then
  echo "  [PASS] ServiceAccount 'ex280sa' exists in project 'apples' (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] ServiceAccount 'ex280sa' NOT found in 'apples' (0 pts)"
  echo "         --> Run: oc create sa ex280sa -n apples"
fi

# Check 2: anyuid SCC granted (checks RBAC rolebinding, authorization, and legacy SCC object)
if [ "$(oc auth can-i use scc/anyuid -n apples --as=system:serviceaccount:apples:ex280sa 2>/dev/null)" = "yes" ] || \
   [ "$(oc auth can-i use scc/anyuid --as=system:serviceaccount:apples:ex280sa 2>/dev/null)" = "yes" ] || \
   oc get rolebinding,clusterrolebinding -n apples -o json 2>/dev/null | grep -qE 'system:openshift:scc:anyuid.*ex280sa|ex280sa.*anyuid' || \
   oc get scc anyuid -o yaml 2>/dev/null | grep -q 'ex280sa'; then
  echo "  [PASS] 'anyuid' SCC successfully assigned to 'ex280sa' (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] 'anyuid' SCC is NOT assigned to 'ex280sa' (0 pts)"
  echo "         --> Run: oc adm policy add-scc-to-user anyuid -z ex280sa -n apples"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
