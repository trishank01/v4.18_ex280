#!/bin/bash
echo ">>> Verifying Q03: Project Permissions..."
S=0
[ "$(oc auth can-i create deployment -n apollo --as armstrong 2>/dev/null)" = "yes" ] && S=$((S+25))
[ "$(oc auth can-i create deployment -n gemini --as armstrong 2>/dev/null)" = "yes" ] && S=$((S+25))
[ "$(oc auth can-i get pods -n titan --as wozniak 2>/dev/null)" = "yes" ] && S=$((S+25))
[ "$(oc auth can-i create deployment -n titan --as wozniak 2>/dev/null)" = "no" ] && S=$((S+25))
echo "🎯 FINAL SCORE: $S / 100 Points ($S%)"
