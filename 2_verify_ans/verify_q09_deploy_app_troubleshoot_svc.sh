#!/bin/bash
echo "=========================================================="
echo "  Verifying Q09: oranges Deployment & Service Selector"
echo "=========================================================="
S=0

# Check 1: Deployment uses SA ex280sa
SA=$(oc get deployment oranges -n apples -o jsonpath='{.spec.template.spec.serviceAccountName}' 2>/dev/null)
if [ "$SA" = "ex280sa" ]; then
  echo "  [PASS] Deployment 'oranges' uses ServiceAccount 'ex280sa' (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] Deployment 'oranges' is NOT using SA 'ex280sa' (Found: '$SA') (0 pts)"
  echo "         --> Run: oc set serviceaccount deployment/oranges ex280sa -n apples"
fi

# Check 2: Service has active endpoint IPs
EPS=$(oc get endpoints oranges -n apples -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null | wc -w)
if [ "$EPS" -gt 0 ]; then
  echo "  [PASS] Service 'oranges' has active endpoint targets ($EPS pods mapped) (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] Service 'oranges' has NO endpoints (Selector does not match pod labels!) (0 pts)"
  echo "         --> Check pod labels with 'oc get pods -n apples --show-labels' and update 'oc edit svc oranges -n apples'"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
