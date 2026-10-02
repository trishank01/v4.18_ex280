#!/bin/bash
echo "=========================================================="
echo "  Verifying Q16: Custom Project Template with LimitRange"
echo "=========================================================="
S=0

TPL=$(oc get projects.config.openshift.io cluster -o jsonpath='{.spec.projectRequestTemplate.name}' 2>/dev/null)
if [ -n "$TPL" ]; then
  echo "  [PASS] Cluster configured with projectRequestTemplate: '$TPL' (+40 pts)"
  S=$((S+40))
else
  echo "  [FAIL] No projectRequestTemplate set in 'projects.config.openshift.io cluster' (0 pts)"
  echo "         --> Run: oc edit projects.config.openshift.io cluster (set spec.projectRequestTemplate.name)"
fi

echo "  --> Testing new project creation to verify automatic LimitRange bootstrap..."
TEST_PROJ="test-q16-$RANDOM"
oc new-project $TEST_PROJ &>/dev/null
sleep 2

if oc get limitrange ${TEST_PROJ}-limits -n $TEST_PROJ &>/dev/null; then
  echo "  [PASS] Automatic LimitRange '${TEST_PROJ}-limits' verified in new project (+60 pts)"
  S=$((S+60))
else
  echo "  [FAIL] LimitRange '${TEST_PROJ}-limits' NOT automatically created in new project (0 pts)"
fi
oc delete project $TEST_PROJ &>/dev/null || true

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
