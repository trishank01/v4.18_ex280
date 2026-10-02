#!/bin/bash
echo "=========================================================="
echo "  Verifying Q04: Groups & Project RoleBindings"
echo "=========================================================="
S=0

# Check 1: commander group has armstrong
if oc get group commander -o jsonpath='{.users}' 2>/dev/null | grep -q 'armstrong'; then
  echo "  [PASS] Group 'commander' exists and contains user 'armstrong' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] Group 'commander' missing or does NOT contain 'armstrong' (0 pts)"
  echo "         --> Run: oc adm groups new commander && oc adm groups add-users commander armstrong"
fi

# Check 2: pilot group has collins and aldrin
if oc get group pilot -o jsonpath='{.users}' 2>/dev/null | grep -q 'collins' && \
   oc get group pilot -o jsonpath='{.users}' 2>/dev/null | grep -q 'aldrin'; then
  echo "  [PASS] Group 'pilot' exists and contains users 'collins' & 'aldrin' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] Group 'pilot' missing or does NOT contain 'collins' and 'aldrin' (0 pts)"
  echo "         --> Run: oc adm groups new pilot && oc adm groups add-users pilot collins aldrin"
fi

# Check 3: commander has edit in apollo
if [ "$(oc auth can-i create pod -n apollo --as u --as-group commander 2>/dev/null)" = "yes" ] || \
   [ "$(oc auth can-i create pod -n apollo --as armstrong --as-group commander 2>/dev/null)" = "yes" ] || \
   oc get rolebinding -n apollo -o json 2>/dev/null | grep -q '"name": *"commander"'; then
  echo "  [PASS] Members of 'commander' have 'edit' permissions in 'apollo' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] 'commander' does NOT have 'edit' permissions in 'apollo' (0 pts)"
  echo "         --> Run: oc adm policy add-role-to-group edit commander -n apollo"
fi

# Check 4: pilot has view in apollo and cannot edit
if { [ "$(oc auth can-i get pods -n apollo --as u --as-group pilot 2>/dev/null)" = "yes" ] || \
     [ "$(oc auth can-i get pods -n apollo --as collins --as-group pilot 2>/dev/null)" = "yes" ] || \
     oc get rolebinding -n apollo -o json 2>/dev/null | grep -q '"name": *"pilot"'; } && \
   [ "$(oc auth can-i create pod -n apollo --as u --as-group pilot 2>/dev/null)" != "yes" ]; then
  echo "  [PASS] Members of 'pilot' have 'view' permissions in 'apollo' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] 'pilot' does NOT have proper 'view' permissions in 'apollo' (0 pts)"
  echo "         --> Run: oc adm policy add-role-to-group view pilot -n apollo"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
