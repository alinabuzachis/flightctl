#!/usr/bin/env bash
set -x -euo pipefail

which kubectl 2>/dev/null 1>/dev/null
if [ $? -eq 0 ]; then
    echo "Kubectl already installed"
    exit 0
fi

LOCAL_ARCH=$(uname -m)
if [ "${TARGET_ARCH}" ]; then
    LOCAL_ARCH=${TARGET_ARCH}
fi

case "${LOCAL_ARCH}" in
  i686)
    K8S_ARCH=386
    ;;
  x86_64)
    K8S_ARCH=amd64
    ;;
  aarch64*)
    K8S_ARCH=arm64
    ;;
  386|amd64|arm64)
    K8S_ARCH=${LOCAL_ARCH}
    ;;
  *)
esac

STABLE=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${STABLE}/bin/linux/${K8S_ARCH}/kubectl"
curl -LO "https://dl.k8s.io/${STABLE}/bin/linux/${K8S_ARCH}/kubectl.sha256" &> /dev/null
echo "Validating kubectl ..."
echo "$(<kubectl.sha256)  kubectl" | sha256sum --check
rm kubectl.sha256
echo "Installing kubectl ..."
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

which kubectl 2>/dev/null 1>/dev/null
if [ $? -eq 0 ]; then
    echo "Helm already installed"
    exit 0
fi

