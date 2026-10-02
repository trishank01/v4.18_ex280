#!/bin/bash
echo "=========================================================="
echo "  Setting up Q07: Helm Chart Scenario"
echo "=========================================================="
echo "[1/2] Preparing project 'aeti-service'..."
oc new-project aeti-service &>/dev/null || true
echo "[2/2] Cleaning old helm releases in 'aeti-service'..."
helm uninstall myapp -n aeti-service &>/dev/null || true
echo ">>> Q07 Setup Complete: aeti-service project clean and ready."
echo "=========================================================="
