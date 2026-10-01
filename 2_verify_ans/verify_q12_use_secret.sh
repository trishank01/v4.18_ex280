#!/bin/bash
echo ">>> Verifying Q12: App using secret magic..."
S=0
(oc get deployment red -n math -o jsonpath='{.spec.template.spec.containers[*].envFrom[*].secretRef.name}' 2>/dev/null | grep -q 'magic' || oc get deployment red -n math -o jsonpath='{.spec.template.spec.containers[*].env[*].valueFrom.secretKeyRef.name}' 2>/dev/null | grep -q 'magic') && S=$((S+100))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
