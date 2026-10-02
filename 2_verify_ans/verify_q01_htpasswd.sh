#!/bin/bash
echo "=========================================================="
echo "  Verifying Q01: HTPasswd Identity Provider"
echo "=========================================================="

CURRENT_USER=$(oc whoami 2>/dev/null)
if [ "$CURRENT_USER" = "armstrong" ] || [ "$CURRENT_USER" = "collins" ] || [ "$CURRENT_USER" = "aldrin" ] || [ "$CURRENT_USER" = "jobs" ] || [ "$CURRENT_USER" = "wozniak" ]; then
  echo "⚠️  WARNING: You are currently logged in as regular user '$CURRENT_USER'."
  echo "    Please login as admin/kubeadmin to run verification:"
  echo "    oc login -u kubeadmin -p <password>"
  echo "----------------------------------------------------------"
fi

S=0

# Check 1: Secret exists in openshift-config
if oc get secret ex280-idp-secret -n openshift-config &>/dev/null; then
  echo "  [PASS] Secret 'ex280-idp-secret' found in openshift-config (+20 pts)"
  S=$((S+20))
else
  echo "  [FAIL] Secret 'ex280-idp-secret' NOT found in openshift-config (0 pts)"
  echo "         --> Run: oc create secret generic ex280-idp-secret --from-file=htpasswd=htpasswd -n openshift-config"
fi

# Check 2: OAuth cluster contains ex280-htpasswd
if oc get oauth cluster -o json 2>/dev/null | grep -q 'ex280-htpasswd'; then
  echo "  [PASS] Identity provider 'ex280-htpasswd' configured in OAuth (+20 pts)"
  S=$((S+20))
else
  echo "  [FAIL] Identity provider 'ex280-htpasswd' NOT found in OAuth cluster (0 pts)"
  echo "         --> Add ex280-htpasswd provider under spec.identityProviders in 'oc edit oauth cluster'"
fi

# Use isolated kubeconfig so current admin session is protected
TMP_KUBECONFIG=$(mktemp)
cp -f "${KUBECONFIG:-$HOME/.kube/config}" "$TMP_KUBECONFIG" 2>/dev/null
export KUBECONFIG="$TMP_KUBECONFIG"

SERVER=$(oc whoami --show-server 2>/dev/null)
[ -z "$SERVER" ] && SERVER="https://api.ocp4.example.com:6443"

# Check 3: Test logins for all 5 users
echo ""
echo "--- Testing User Logins ---"
for u in armstrong:indiaco collins:verastar aldrin:moonhar jobs:eastiver wozniak:glimpse; do
  user=${u%%:*}
  pass=${u##*:}
  if oc login "$SERVER" -u "$user" -p "$pass" --insecure-skip-tls-verify=true &>/dev/null ||      oc login -u "$user" -p "$pass" --insecure-skip-tls-verify=true &>/dev/null ||      oc login "$SERVER" -u "$user" -p "${user}123" --insecure-skip-tls-verify=true &>/dev/null ||      oc login -u "$user" -p "${user}123" --insecure-skip-tls-verify=true &>/dev/null; then
    echo "  [PASS] Login successful for user '$user' (+12 pts)"
    S=$((S+12))
  else
    echo "  [FAIL] Login failed for user '$user' (0 pts)"
    echo "         --> Expected password: '$pass' (or '${user}123')"
  fi
done

rm -f "$TMP_KUBECONFIG"
unset KUBECONFIG

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
