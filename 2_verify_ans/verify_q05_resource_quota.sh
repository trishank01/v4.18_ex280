#!/bin/bash
echo "=========================================================="
echo "  Verifying Q05: ResourceQuota in Project manhattan"
echo "=========================================================="
S=0

# Check 1: Quota exists
if oc get resourcequota ex280-quota -n manhattan &>/dev/null; then
  echo "  [PASS] ResourceQuota 'ex280-quota' exists in 'manhattan' (+20 pts)"
  S=$((S+20))
else
  echo "  [FAIL] ResourceQuota 'ex280-quota' NOT found in 'manhattan' (0 pts)"
  echo "         --> Run: oc create quota ex280-quota --hard=cpu=2,memory=15Gi,pods=3,services=6,replicationcontrollers=3 -n manhattan"
  echo "=========================================================="
  echo "🎯 FINAL SCORE: 0 / 100 Points (0%)"
  echo "=========================================================="
  exit 0
fi

# Check 2: CPU hard limit
CPU=$(oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.cpu}' 2>/dev/null)
if [ "$CPU" = "2" ]; then
  echo "  [PASS] CPU limit is set to 2 cores (+20 pts)"
  S=$((S+20))
else
  echo "  [FAIL] CPU limit mismatch (Found: '$CPU', Expected: '2') (0 pts)"
fi

# Check 3: Memory hard limit
MEM=$(oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.memory}' 2>/dev/null)
if echo "$MEM" | grep -qE '15G|15Gi'; then
  echo "  [PASS] Memory limit is set to 15Gi (+20 pts)"
  S=$((S+20))
else
  echo "  [FAIL] Memory limit mismatch (Found: '$MEM', Expected: '15Gi') (0 pts)"
fi

# Check 4: Pods limit
PODS=$(oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.pods}' 2>/dev/null)
if [ "$PODS" = "3" ]; then
  echo "  [PASS] Pods limit is set to 3 (+20 pts)"
  S=$((S+20))
else
  echo "  [FAIL] Pods limit mismatch (Found: '$PODS', Expected: '3') (0 pts)"
fi

# Check 5: Services and ReplicationControllers
SVCS=$(oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.services}' 2>/dev/null)
RC=$(oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.replicationcontrollers}' 2>/dev/null)
if [ "$SVCS" = "6" ] && [ "$RC" = "3" ]; then
  echo "  [PASS] Services limit (6) & ReplicationControllers limit (3) configured (+20 pts)"
  S=$((S+20))
else
  echo "  [FAIL] Services or RC mismatch (Services: '$SVCS', RC: '$RC') (0 pts)"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
