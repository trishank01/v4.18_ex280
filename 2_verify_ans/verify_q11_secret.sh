#!/bin/bash
echo "=========================================================="
echo "  Verifying Q11: Secret Creation"
echo "=========================================================="
S=0

# Check 1: Secret exists
if oc get secret magic -n math &>/dev/null; then
  echo "  [PASS] Secret 'magic' exists in project 'math' (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] Secret 'magic' NOT found in project 'math' (0 pts)"
  echo "         --> Run: oc create secret generic magic --from-literal=ACCESS_STRING=ASDA142hfh-gfrhhueo-erfdk345v -n math"
  echo "=========================================================="
  echo "🎯 FINAL SCORE: 0 / 100 Points (0%)"
  echo "=========================================================="
  exit 0
fi

# Check 2: Key and value
VAL=$(oc get secret magic -n math -o jsonpath='{.data.ACCESS_STRING}' 2>/dev/null | base64 -d 2>/dev/null)
if [ "$VAL" = "ASDA142hfh-gfrhhueo-erfdk345v" ]; then
  echo "  [PASS] Key 'ACCESS_STRING' matches required value (+50 pts)"
  S=$((S+50))
else
  echo "  [FAIL] Key value mismatch (Found: '$VAL') (0 pts)"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
