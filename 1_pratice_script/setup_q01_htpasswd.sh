#!/bin/bash
echo "=========================================================="
echo "  Setting up Q01: HTPasswd Identity Provider Scenario"
echo "=========================================================="
echo "[1/4] Removing existing user identities and accounts..."
oc delete secret ex280-idp-secret -n openshift-config &>/dev/null
oc delete user armstrong collins aldrin jobs wozniak &>/dev/null
oc delete identity $(oc get identity -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n' | grep 'ex280') &>/dev/null
echo "  --> Cleaned up old users and secrets."

echo "[2/4] Resetting Cluster OAuth configuration..."
python3 -c "import json, subprocess
try:
    raw = subprocess.check_output(['oc','get','oauth','cluster','-o','json'])
    doc = json.loads(raw)
    idps = doc.get('spec', {}).get('identityProviders', [])
    doc['spec']['identityProviders'] = [i for i in idps if i.get('name') != 'ex280-htpasswd']
    subprocess.run(['oc','apply','-f','-'], input=json.dumps(doc), text=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except Exception:
    pass" &>/dev/null
echo "  --> OAuth cluster reset to base state."

echo "[3/4] Cleaning local temporary password files..."
rm -f ~/exam-user ~/htpassfile
echo "  --> Removed local password files."

echo "[4/4] Environment Ready!"
echo ">>> Q01 Setup Complete: Practice creating htpasswd, secret and OAuth IDP."
echo "=========================================================="
