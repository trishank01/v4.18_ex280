#!/bin/bash
echo ">>> Verifying Q13: NetworkPolicy db-allow-mysql-conn..."
S=0
oc get netpol db-allow-mysql-conn -n database &>/dev/null && S=$((S+25))
oc get netpol db-allow-mysql-conn -n database -o jsonpath='{.spec.podSelector.matchLabels}' 2>/dev/null | grep -q 'network.openshift.io/policy-group' && S=$((S+25))
oc get netpol db-allow-mysql-conn -n database -o jsonpath='{.spec.ingress[*].from[*].namespaceSelector.matchLabels.team}' 2>/dev/null | grep -q 'devsecops' && S=$((S+25))
oc get netpol db-allow-mysql-conn -n database -o jsonpath='{.spec.ingress[*].ports[*].port}' 2>/dev/null | grep -q '3306' && S=$((S+25))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
