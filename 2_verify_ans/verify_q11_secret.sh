#!/bin/bash
echo ">>> Verifying Q11: Secret creation in math..."
S=0
oc get secret magic -n math &>/dev/null && S=$((S+50))
[ "$(oc get secret magic -n math -o jsonpath='{.data.ACCESS_STRING}' 2>/dev/null | base64 -d 2>/dev/null)" = "ASDA142hfh-gfrhhueo-erfdk345v" ] && S=$((S+50))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
