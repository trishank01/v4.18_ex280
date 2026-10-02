#!/bin/bash
echo ">>> Verifying Q14: Troubleshooting atlas app..."
S=0
MEM=$(oc get deployment atlas -n mercury -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null)
if [ "$MEM" = "1Gi" ] || [ "$MEM" = "1G" ]; then
  S=$((S+50))
fi
[ $(oc get pods -n mercury --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l) -gt 0 ] && S=$((S+50))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
