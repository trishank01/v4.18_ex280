#!/bin/bash
echo ">>> Verifying Q09: oranges Deployment & Service Selector..."
S=0
[ "$(oc get deployment oranges -n apples -o jsonpath='{.spec.template.spec.serviceAccountName}' 2>/dev/null)" = "ex280sa" ] && S=$((S+50))
[ $(oc get endpoints oranges -n apples -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null | wc -w) -gt 0 ] && S=$((S+50))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
