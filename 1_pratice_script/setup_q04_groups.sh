#!/bin/bash
echo ">>> Setting up Q04: Resetting Groups..."
oc delete group commander pilot &>/dev/null || true
oc new-project apollo &>/dev/null || true
oc adm policy remove-role-from-group edit commander -n apollo &>/dev/null || true
oc adm policy remove-role-from-group view pilot -n apollo &>/dev/null || true
echo ">>> Q04 Setup Complete: Clean groups state."
