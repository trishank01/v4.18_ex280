#!/bin/bash
echo ">>> Verifying Q07: Helm Chart Deployment..."
S=0
(helm list -n aeti-service 2>/dev/null | grep -qE 'myapp|redhat-movie|example-app') && S=$((S+50))
[ $(oc get pods -n aeti-service --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l) -gt 0 ] && S=$((S+50))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
