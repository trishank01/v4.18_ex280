#!/bin/bash
echo ">>> Verifying Q06: Secure Edge Route..."
S=0
oc get route oxcart -n area51 &>/dev/null && S=$((S+25))
[ "$(oc get route oxcart -n area51 -o jsonpath='{.spec.tls.termination}' 2>/dev/null)" = "edge" ] && S=$((S+25))
[ "$(oc get route oxcart -n area51 -o jsonpath='{.spec.host}' 2>/dev/null)" = "oxcart.apps.ocp4.example.com" ] && S=$((S+25))
[ -n "$(oc get route oxcart -n area51 -o jsonpath='{.spec.tls.certificate}' 2>/dev/null)" ] && S=$((S+25))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
