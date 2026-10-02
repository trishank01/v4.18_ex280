#!/bin/bash
echo "=========================================================="
echo "  Verifying Q03: Project Permissions (admin & view)"
echo "=========================================================="
S=0

# Check 1: armstrong is admin in apollo
if [ "$(oc auth can-i create deployment -n apollo --as armstrong 2>/dev/null)" = "yes" ]; then
  echo "  [PASS] User 'armstrong' has admin role in 'apollo' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] User 'armstrong' is NOT admin in 'apollo' (0 pts)"
  echo "         --> Run: oc adm policy add-role-to-user admin armstrong -n apollo"
fi

# Check 2: armstrong is admin in gemini
if [ "$(oc auth can-i create deployment -n gemini --as armstrong 2>/dev/null)" = "yes" ]; then
  echo "  [PASS] User 'armstrong' has admin role in 'gemini' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] User 'armstrong' is NOT admin in 'gemini' (0 pts)"
  echo "         --> Run: oc adm policy add-role-to-user admin armstrong -n gemini"
fi

# Check 3: wozniak can view titan
if [ "$(oc auth can-i get pods -n titan --as wozniak 2>/dev/null)" = "yes" ]; then
  echo "  [PASS] User 'wozniak' can view project 'titan' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] User 'wozniak' CANNOT view project 'titan' (0 pts)"
  echo "         --> Run: oc adm policy add-role-to-user view wozniak -n titan"
fi

# Check 4: wozniak cannot administer titan
if [ "$(oc auth can-i create deployment -n titan --as wozniak 2>/dev/null)" = "no" ]; then
  echo "  [PASS] User 'wozniak' cannot administer or create resources in 'titan' (+25 pts)"
  S=$((S+25))
else
  echo "  [FAIL] User 'wozniak' has write/admin permissions in 'titan' (Should be view only!) (0 pts)"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
