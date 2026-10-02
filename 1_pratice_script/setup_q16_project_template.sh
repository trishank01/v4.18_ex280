#!/bin/bash
echo ">>> Setting up Q16: Resetting Project Template..."
python3 -c "import json, subprocess
try:
    raw = subprocess.check_output(['oc','get','projects.config.openshift.io','cluster','-o','json'])
    doc = json.loads(raw)
    if 'projectRequestTemplate' in doc.get('spec', {}):
        del doc['spec']['projectRequestTemplate']
        subprocess.run(['oc','apply','-f','-'], input=json.dumps(doc), text=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except Exception:
    pass" &>/dev/null
oc delete template project-request -n openshift-config &>/dev/null || true
echo ">>> Q16 Setup Complete: Clean project template state."
