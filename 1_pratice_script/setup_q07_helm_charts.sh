#!/bin/bash
echo ">>> Setting up Q07: Preparing aeti-service project..."
oc new-project aeti-service &>/dev/null || true
helm uninstall myapp -n aeti-service &>/dev/null || true
echo ">>> Q07 Setup Complete: aeti-service project clean."
