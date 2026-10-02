#!/bin/bash
echo ">>> Verifying Q10: Manual Scaling of hydra..."
S=0
[ "$(oc get deployment hydra -n lerna -o jsonpath='{.spec.replicas}' 2>/dev/null)" = "5" ] && S=$((S+100))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
