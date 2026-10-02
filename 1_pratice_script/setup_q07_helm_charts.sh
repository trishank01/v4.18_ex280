#!/bin/bash
echo "=========================================================="
echo "  Setting up Q07: Helm Chart Scenario"
echo "=========================================================="
echo "[1/4] Preparing project 'aeti-service'..."
oc new-project aeti-service &>/dev/null || true

echo "[2/4] Cleaning old helm releases in 'aeti-service'..."
helm uninstall myapp -n aeti-service &>/dev/null || true

echo "[3/4] Setting up mock Helm repository for practice..."
MOCK_DIR="/tmp/mock-helm"
rm -rf "$MOCK_DIR"
mkdir -p "$MOCK_DIR/charts"

# Create a valid chart for redhat-movie
helm create "$MOCK_DIR/redhat-movie" &>/dev/null
sed -i 's|repository: nginx|repository: ubi8/ubi-minimal|g' "$MOCK_DIR/redhat-movie/values.yaml" 2>/dev/null || true
sed -i 's|tag: ""|tag: "latest"|g' "$MOCK_DIR/redhat-movie/values.yaml" 2>/dev/null || true

helm package "$MOCK_DIR/redhat-movie" -d "$MOCK_DIR/charts" &>/dev/null
helm repo index "$MOCK_DIR/charts" &>/dev/null

# Start python http server in background on port 8089 if not running
pkill -f "http.server 8089" 2>/dev/null || true
python3 -m http.server 8089 --directory "$MOCK_DIR" &>/dev/null &
sleep 1

# Try to add domain mapping to /etc/hosts if passwordless sudo is available
if sudo -n true 2>/dev/null; then
  if ! grep -q 'helm.domain6.example.com' /etc/hosts 2>/dev/null; then
    echo "127.0.0.1 helm.domain6.example.com" | sudo tee -a /etc/hosts &>/dev/null || true
  fi
fi

echo "[4/4] Environment Ready!"
echo ">>> Q07 Setup Complete: Helm practice repo is ready at http://127.0.0.1:8089/charts"
echo "    In practice, run:"
echo "    helm repo add custom-repo http://127.0.0.1:8089/charts"
echo "    helm repo update"
echo "    helm install myapp custom-repo/redhat-movie -n aeti-service"
echo "=========================================================="
