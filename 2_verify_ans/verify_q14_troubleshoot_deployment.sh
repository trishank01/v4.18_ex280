#!/bin/bash
echo "=========================================================="
echo "  Verifying Q14: Troubleshoot Deployment (atlas)"
echo "=========================================================="
S=0

MEM=$(oc get deployment atlas -n mercury -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null)
if [ "$MEM" = "1Gi" ] || [ "$MEM" = "1G" ]; then
  echo "  [PASS] Memory request adjusted to 1Gi (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] Memory request is NOT 1Gi (Found: '$MEM') (0 pts)"
  echo "         --> Edit deployment: oc edit deployment atlas -n mercury (set requests.memory to 1Gi)"
fi

RUNNING=$(oc get pods -n mercury --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l)
if [ "$RUNNING" -gt 0 ]; then
  echo "  [PASS] Pod 'atlas' successfully transitioned to Running status (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] Pod 'atlas' is still NOT Running (Check 'oc describe pod -n mercury') (0 pts)"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
