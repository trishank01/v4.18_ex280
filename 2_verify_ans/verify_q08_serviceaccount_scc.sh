#!/bin/bash
echo ">>> Verifying Q08: ServiceAccount & anyuid SCC..."
S=0
oc get sa ex280sa -n apples &>/dev/null && S=$((S+50))
oc get scc anyuid -o jsonpath='{.users}' 2>/dev/null | grep -q 'apples:ex280sa' && S=$((S+50))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
