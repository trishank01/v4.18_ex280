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

# Check 2: Service has active endpoint IPs or matches deployment selector
EPS=$(oc get endpoints oranges -n apples -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null | wc -w)
SVC_SEL=$(oc get svc oranges -n apples -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$EPS" -gt 0 ] || [ "$SVC_SEL" = "oranges" ]; then
  echo "  [PASS] Service 'oranges' selector correctly configured (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] Service 'oranges' has NO endpoints and invalid selector (0 pts)"
  echo "         --> Check pod labels with 'oc get pods -n apples --show-labels' and update 'oc edit svc oranges -n apples'"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
