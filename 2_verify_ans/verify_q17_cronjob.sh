#!/bin/bash
echo ">>> Verifying Q17: CronJob ipsum in lorem..."
S=0
oc get cronjob ipsum -n lorem &>/dev/null && S=$((S+30))
[ "$(oc get cronjob ipsum -n lorem -o jsonpath='{.spec.schedule}' 2>/dev/null)" = "* * * * *" ] && S=$((S+35))
[ "$(oc get cronjob ipsum -n lorem -o jsonpath='{.spec.successfulJobsHistoryLimit}' 2>/dev/null)" = "10" -o "$(oc get cronjob ipsum -n lorem -o jsonpath='{.spec.successfulJobHistoryLimit}' 2>/dev/null)" = "10" ] && S=$((S+35))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
