#!/bin/bash
echo ">>> Verifying Q15: File Integrity Operator..."
S=0
(oc get sub -n openshift-file-integrity 2>/dev/null | grep -q 'file-integrity') && S=$((S+50))
[ "$(oc get sub -n openshift-file-integrity -o jsonpath='{.items[0].spec.installPlanApproval}' 2>/dev/null)" = "Automatic" ] && S=$((S+50))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
