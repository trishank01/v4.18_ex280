#!/bin/bash
echo ">>> Setting up Q01: Resetting HTPasswd Identity Provider..."
oc delete secret ex280-idp-secret -n openshift-config &>/dev/null
oc delete user armstrong collins aldrin jobs wozniak &>/dev/null
oc delete identity $(oc get identity -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n' | grep 'ex280') &>/dev/null
python3 -c "import json, subprocess
try:
    raw = subprocess.check_output(['oc','get','oauth','cluster','-o','json'])
    doc = json.loads(raw)
    idps = doc.get('spec', {}).get('identityProviders', [])
    doc['spec']['identityProviders'] = [i for i in idps if i.get('name') != 'ex280-htpasswd']
    subprocess.run(['oc','apply','-f','-'], input=json.dumps(doc), text=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except Exception:
    pass" &>/dev/null
rm -f ~/exam-user ~/htpassfile
echo ">>> Q01 Setup Complete: Clean cluster OAuth state ready for practice."
