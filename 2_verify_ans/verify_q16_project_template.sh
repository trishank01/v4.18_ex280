#!/bin/bash
echo ">>> Verifying Q16: Custom Project Template with LimitRange..."
S=0
TPL=$(oc get projects.config.openshift.io cluster -o jsonpath='{.spec.projectRequestTemplate.name}' 2>/dev/null)
[ -n "$TPL" ] && S=$((S+40))
TEST_PROJ="test-temp-$RANDOM"
oc new-project $TEST_PROJ &>/dev/null
sleep 2
if oc get limitrange ${TEST_PROJ}-limits -n $TEST_PROJ &>/dev/null; then
  S=$((S+60))
fi
oc delete project $TEST_PROJ &>/dev/null || true
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
