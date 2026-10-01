#!/bin/bash
echo ">>> Verifying Q04: Groups & Rolebindings..."
S=0
oc get group commander -o jsonpath='{.users}' 2>/dev/null | grep -q 'armstrong' && S=$((S+25))
oc get group pilot -o jsonpath='{.users}' 2>/dev/null | grep -q 'collins' && oc get group pilot -o jsonpath='{.users}' 2>/dev/null | grep -q 'aldrin' && S=$((S+25))
[ "$(oc auth can-i create pod -n apollo --as armstrong 2>/dev/null)" = "yes" ] && S=$((S+25))
[ "$(oc auth can-i get pods -n apollo --as collins 2>/dev/null)" = "yes" ] && [ "$(oc auth can-i create pod -n apollo --as collins 2>/dev/null)" = "no" ] && S=$((S+25))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
