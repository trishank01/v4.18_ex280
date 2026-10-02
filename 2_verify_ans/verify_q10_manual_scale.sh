#!/bin/bash
echo "=========================================================="
echo "  Verifying Q10: Manual Scaling"
echo "=========================================================="
S=0
REPLICAS=$(oc get deployment hydra -n lerna -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$REPLICAS" = "5" ]; then
  echo "  [PASS] Deployment 'hydra' has exactly 5 replicas (+100 pts)"
  S=$((S+100))
else
  echo "  [FAIL] Replicas count mismatch (Found: '$REPLICAS', Expected: '5') (0 pts)"
  echo "         --> Run: oc scale deployment hydra --replicas=5 -n lerna"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
