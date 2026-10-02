#!/bin/bash
echo "=========================================================="
echo "  Verifying Q06: Secure Edge TLS Route"
echo "=========================================================="
S=0

# Check 1: Route exists
if oc get route oxcart -n area51 &>/dev/null; then
  echo "  [PASS] Route 'oxcart' found in project 'area51' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] Route 'oxcart' NOT found in project 'area51' (0 pts)"
  echo "         --> Run: oc create route edge oxcart --service=oxcart --key=oxcart.key --cert=oxcart.crt --hostname=oxcart.apps.ocp4.example.com -n area51"
  echo "=========================================================="
  echo "🎯 FINAL SCORE: 0 / 100 Points (0%)"
  echo "=========================================================="
  exit 0
fi

# Check 2: TLS Termination is Edge
TERM=$(oc get route oxcart -n area51 -o jsonpath='{.spec.tls.termination}' 2>/dev/null)
if [ "$TERM" = "edge" ]; then
  echo "  [PASS] TLS termination type is 'edge' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] TLS termination is NOT 'edge' (Found: '$TERM') (0 pts)"
fi

# Check 3: Hostname
HOST=$(oc get route oxcart -n area51 -o jsonpath='{.spec.host}' 2>/dev/null)
if [ "$HOST" = "oxcart.apps.ocp4.example.com" ]; then
  echo "  [PASS] Route hostname is 'oxcart.apps.ocp4.example.com' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] Hostname mismatch (Found: '$HOST', Expected: 'oxcart.apps.ocp4.example.com') (0 pts)"
fi

# Check 4: Certificate is configured
CERT=$(oc get route oxcart -n area51 -o jsonpath='{.spec.tls.certificate}' 2>/dev/null)
if [ -n "$CERT" ]; then
  echo "  [PASS] TLS Certificate and Key are populated (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] TLS Certificate is missing on the route (0 pts)"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
