#!/bin/bash
echo "=========================================================="
echo "  Verifying Q12: Secret Injection into Deployment"
echo "=========================================================="
S=0

# Check: Secret magic is attached to deployment
if oc get deployment red -n math -o jsonpath='{.spec.template.spec.containers[*].envFrom[*].secretRef.name}' 2>/dev/null | grep -q 'magic' ||    oc get deployment red -n math -o jsonpath='{.spec.template.spec.containers[*].env[*].valueFrom.secretKeyRef.name}' 2>/dev/null | grep -q 'magic'; then
  echo "  [PASS] Secret 'magic' injected into deployment 'red' (+100 pts)"
  S=$((S+100))
else
  echo "  [FAIL] Secret 'magic' is NOT injected into deployment 'red' (0 pts)"
  echo "         --> Run: oc set env deployment/red --from=secret/magic -n math"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
