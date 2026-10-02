#!/bin/bash
echo "=========================================================="
echo "  Verifying Q07: Helm Chart Deployment"
echo "=========================================================="
S=0

# Check 1: Helm release exists
if helm list -n aeti-service 2>/dev/null | grep -qE 'myapp|redhat-movie|example-app'; then
  echo "  [PASS] Helm release deployed in project 'aeti-service' (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] No active Helm release found in 'aeti-service' (0 pts)"
  echo "         --> Run: helm repo add custom-repo http://helm.domain6.example.com/charts/ && helm install myapp custom-repo/redhat-movie -n aeti-service"
fi

# Check 2: Pods are running
RUNNING_PODS=$(oc get pods -n aeti-service --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l)
if [ "$RUNNING_PODS" -gt 0 ]; then
  echo "  [PASS] Application pod is Running in 'aeti-service' (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] No Running pods found in 'aeti-service' (0 pts)"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
