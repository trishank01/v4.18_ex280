#!/bin/bash
echo "=========================================================="
echo "  Verifying Q13: NetworkPolicy db-allow-mysql-conn"
echo "=========================================================="
S=0

# Check 1: NetworkPolicy exists
if oc get netpol db-allow-mysql-conn -n database &>/dev/null; then
  echo "  [PASS] NetworkPolicy 'db-allow-mysql-conn' found in 'database' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] NetworkPolicy 'db-allow-mysql-conn' NOT found in 'database' (0 pts)"
  echo "=========================================================="
  echo "🎯 FINAL SCORE: 0 / 100 Points (0%)"
  echo "=========================================================="
  exit 0
fi

# Check 2: Pod selector label
if oc get netpol db-allow-mysql-conn -n database -o jsonpath='{.spec.podSelector.matchLabels}' 2>/dev/null | grep -q 'network.openshift.io/policy-group' || \
   oc get netpol db-allow-mysql-conn -n database -o yaml 2>/dev/null | grep -q 'network.openshift.io/policy-group'; then
  echo "  [PASS] Target pod selector 'network.openshift.io/policy-group' configured (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] Target pod selector missing 'network.openshift.io/policy-group' (0 pts)"
fi

# Check 3: NamespaceSelector label
if oc get netpol db-allow-mysql-conn -n database -o jsonpath='{.spec.ingress[*].from[*].namespaceSelector.matchLabels.team}' 2>/dev/null | grep -q 'devsecops' || \
   oc get netpol db-allow-mysql-conn -n database -o yaml 2>/dev/null | grep -q 'devsecops'; then
  echo "  [PASS] Ingress namespaceSelector matches 'team=devsecops' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] Ingress namespaceSelector does NOT match 'team=devsecops' (0 pts)"
fi

# Check 4: TCP Port 3306
if oc get netpol db-allow-mysql-conn -n database -o jsonpath='{.spec.ingress[*].ports[*].port}' 2>/dev/null | grep -q '3306' || \
   oc get netpol db-allow-mysql-conn -n database -o yaml 2>/dev/null | grep -q '3306'; then
  echo "  [PASS] Ingress port 3306 TCP allowed (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] Ingress port 3306 TCP NOT specified (0 pts)"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
