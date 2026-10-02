#!/bin/bash
echo "=========================================================="
echo "  Verifying Q01: HTPasswd Identity Provider"
echo "=========================================================="

CURRENT_USER=$(oc whoami 2>/dev/null)
if [ -z "$CURRENT_USER" ]; then
  echo "⚠️  WARNING: You are NOT currently logged in to OpenShift."
  echo "    Please login as kubeadmin/admin first:"
  echo "    oc login -u kubeadmin -p <password>"
  echo "----------------------------------------------------------"
elif [ "$CURRENT_USER" = "armstrong" ] || [ "$CURRENT_USER" = "collins" ] || [ "$CURRENT_USER" = "aldrin" ] || [ "$CURRENT_USER" = "jobs" ] || [ "$CURRENT_USER" = "wozniak" ]; then
  echo "⚠️  WARNING: You are currently logged in as regular user '$CURRENT_USER'."
  echo "    Please login as admin/kubeadmin to run verification:"
  echo "    oc login -u kubeadmin -p <password>"
  echo "----------------------------------------------------------"
else
  echo "  Logged in as: $CURRENT_USER"
  echo "----------------------------------------------------------"
fi

S=0

# Check 1: Secret exists in openshift-config
SECRET_OK=false
if oc get secret ex280-idp-secret -n openshift-config &>/dev/null; then
  echo "  [PASS] Secret 'ex280-idp-secret' found in openshift-config (+20 pts)"
  S=$((S+20))
  SECRET_OK=true
else
  echo "  [FAIL] Secret 'ex280-idp-secret' NOT found in openshift-config (0 pts)"
  echo "         --> Run: oc create secret generic ex280-idp-secret --from-file=htpasswd=htpasswd -n openshift-config"
fi

# Check 2: OAuth cluster contains ex280-htpasswd
IDP_OK=false
if oc get oauth cluster -o json 2>/dev/null | grep -q 'ex280-htpasswd'; then
  echo "  [PASS] Identity provider 'ex280-htpasswd' configured in OAuth (+20 pts)"
  S=$((S+20))
  IDP_OK=true
else
  echo "  [FAIL] Identity provider 'ex280-htpasswd' NOT found in OAuth cluster (0 pts)"
  echo "         --> Add ex280-htpasswd provider under spec.identityProviders in 'oc edit oauth cluster'"
fi

# Check 3: Test logins for all 5 users
echo ""
echo "--- Testing User Logins ---"

if [ "$SECRET_OK" = "false" ] && [ "$IDP_OK" = "false" ]; then
  echo "  [FAIL] Identity Provider & Secret are not configured yet."
  echo "         --> Skipping network login attempts (Configure Secret & OAuth first)."
  for u in armstrong collins aldrin jobs wozniak; do
    echo "  [FAIL] Login test for user '$u' (0 pts)"
  done
else
  # Detect cluster server URL before switching kubeconfig
  SERVER=$(oc whoami --show-server 2>/dev/null)
  if [ -z "$SERVER" ]; then
    SERVER=$(oc config view --minify -o jsonpath='{.clusters[0].cluster.server}' 2>/dev/null)
  fi

  # Use isolated kubeconfig so current admin session is protected
  TMP_KUBECONFIG=$(mktemp)
  cp -f "${KUBECONFIG:-$HOME/.kube/config}" "$TMP_KUBECONFIG" 2>/dev/null
  export KUBECONFIG="$TMP_KUBECONFIG"

  for u in armstrong:indiaco collins:verastar aldrin:moonhar jobs:eastiver wozniak:glimpse; do
    user=${u%%:*}
    pass=${u##*:}
    LOGIN_OK=false

    if [ -n "$SERVER" ]; then
      if timeout 3s oc login "$SERVER" -u "$user" -p "$pass" --insecure-skip-tls-verify=true < /dev/null &>/dev/null; then
        LOGIN_OK=true
      elif timeout 3s oc login "$SERVER" -u "$user" -p "${user}123" --insecure-skip-tls-verify=true < /dev/null &>/dev/null; then
        LOGIN_OK=true
      fi
    else
      if timeout 3s oc login -u "$user" -p "$pass" --insecure-skip-tls-verify=true < /dev/null &>/dev/null; then
        LOGIN_OK=true
      elif timeout 3s oc login -u "$user" -p "${user}123" --insecure-skip-tls-verify=true < /dev/null &>/dev/null; then
        LOGIN_OK=true
      fi
    fi

    if [ "$LOGIN_OK" = "true" ]; then
      echo "  [PASS] Login successful for user '$user' (+12 pts)"
      S=$((S+12))
    else
      echo "  [FAIL] Login failed for user '$user' (0 pts)"
      echo "         --> Expected password: '$pass' (or '${user}123')"
    fi
  done

  rm -f "$TMP_KUBECONFIG"
  unset KUBECONFIG
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
