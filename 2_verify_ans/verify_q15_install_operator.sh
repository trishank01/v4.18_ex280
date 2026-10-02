#!/bin/bash
echo "=========================================================="
echo "  Verifying Q15: File Integrity Operator Installation"
echo "=========================================================="
S=0

# Check 1: Subscription exists
if oc get sub -n openshift-file-integrity 2>/dev/null | grep -q 'file-integrity'; then
  echo "  [PASS] Subscription for 'file-integrity' exists in 'openshift-file-integrity' (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] File Integrity subscription NOT found in 'openshift-file-integrity' (0 pts)"
fi

# Check 2: Approval is Automatic
APPROVAL=$(oc get sub -n openshift-file-integrity -o jsonpath='{.items[0].spec.installPlanApproval}' 2>/dev/null)
if [ "$APPROVAL" = "Automatic" ]; then
  echo "  [PASS] InstallPlan approval strategy is set to 'Automatic' (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] InstallPlan approval is NOT 'Automatic' (Found: '$APPROVAL') (0 pts)"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
