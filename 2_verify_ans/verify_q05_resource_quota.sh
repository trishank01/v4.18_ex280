#!/bin/bash
echo ">>> Verifying Q05: ResourceQuota in manhattan..."
S=0
oc get resourcequota ex280-quota -n manhattan &>/dev/null && S=$((S+20))
[ "$(oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.cpu}' 2>/dev/null)" = "2" ] && S=$((S+20))
oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.memory}' 2>/dev/null | grep -qE '15G|15Gi' && S=$((S+20))
[ "$(oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.pods}' 2>/dev/null)" = "3" ] && S=$((S+20))
[ "$(oc get resourcequota ex280-quota -n manhattan -o jsonpath='{.spec.hard.services}' 2>/dev/null)" = "6" ] && S=$((S+20))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
