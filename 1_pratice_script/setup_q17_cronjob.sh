#!/bin/bash
echo "=========================================================="
echo "  Setting up Q17: Scheduled CronJob Scenario"
echo "=========================================================="
oc new-project lorem &>/dev/null || true
oc delete cronjob ipsum -n lorem &>/dev/null || true
echo ">>> Q17 Setup Complete: Ready to create CronJob 'ipsum' in 'lorem'."
echo "=========================================================="
