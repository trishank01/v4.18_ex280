#!/bin/bash
echo "=========================================================="
echo "  Setting up Q04: User Groups Scenario"
echo "=========================================================="
echo "[1/3] Deleting existing groups 'commander' and 'pilot'..."
oc delete group commander pilot &>/dev/null || true
echo "[2/3] Ensuring project 'apollo' exists..."
oc new-project apollo &>/dev/null || true
echo "[3/3] Removing group role bindings from 'apollo'..."
oc adm policy remove-role-from-group edit commander -n apollo &>/dev/null || true
oc adm policy remove-role-from-group view pilot -n apollo &>/dev/null || true
echo ">>> Q04 Setup Complete: Clean groups state."
echo "=========================================================="
