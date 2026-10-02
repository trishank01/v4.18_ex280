#!/bin/bash
echo "=========================================================="
echo "  Setting up Q16: Custom Project Template Scenario"
echo "=========================================================="
echo "[1/2] Resetting cluster projectRequestTemplate..."
python3 -c "import json, subprocess
try:
    raw = subprocess.check_output(['oc','get','projects.config.openshift.io','cluster','-o','json'])
    doc = json.loads(raw)
    if 'projectRequestTemplate' in doc.get('spec', {}):
        del doc['spec']['projectRequestTemplate']
        subprocess.run(['oc','apply','-f','-'], input=json.dumps(doc), text=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except Exception:
    pass" &>/dev/null
echo "[2/2] Deleting old template 'project-request'..."
oc delete template project-request -n openshift-config &>/dev/null || true
echo ">>> Q16 Setup Complete: Template configuration reset to default."
echo "=========================================================="
