#!/bin/bash
echo "=========================================================="
echo "  Verifying Q17: CronJob (ipsum in project lorem)"
echo "=========================================================="
S=0

# Check 1: Cronjob exists
if oc get cronjob ipsum -n lorem &>/dev/null; then
  echo "  [PASS] CronJob 'ipsum' exists in project 'lorem' (+30 pts)"
  S=$((S+30))
else
  echo "  [FAIL] CronJob 'ipsum' NOT found in project 'lorem' (0 pts)"
  echo "         --> Run: oc create cronjob ipsum --image=registry.domain6.example.com/library/job-runner:latest --schedule="* * * * *" -n lorem"
  echo "=========================================================="
  echo "🎯 FINAL SCORE: 0 / 100 Points (0%)"
  echo "=========================================================="
  exit 0
fi

# Check 2: Schedule
SCHED=$(oc get cronjob ipsum -n lorem -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$SCHED" = "* * * * *" ]; then
  echo "  [PASS] Schedule is set to '* * * * *' (Every minute) (+35 pts)"
  S=$((S+35))
else
  echo "  [FAIL] Schedule mismatch (Found: '$SCHED', Expected: '* * * * *') (0 pts)"
fi

# Check 3: History limit
LIMIT=$(oc get cronjob ipsum -n lorem -o jsonpath='{.spec.successfulJobsHistoryLimit}' 2>/dev/null)
[ -z "$LIMIT" ] && LIMIT=$(oc get cronjob ipsum -n lorem -o jsonpath='{.spec.successfulJobHistoryLimit}' 2>/dev/null)
if [ "$LIMIT" = "10" ]; then
  echo "  [PASS] successfulJobsHistoryLimit is set to 10 (+35 pts)"
  S=$((S+35))
else
  echo "  [FAIL] History limit mismatch (Found: '$LIMIT', Expected: '10') (0 pts)"
  echo "         --> Run: oc patch cronjob ipsum --type='merge' -p '{"spec":{"successfulJobsHistoryLimit":10}}' -n lorem"
fi

echo "=========================================================="
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
echo "=========================================================="
