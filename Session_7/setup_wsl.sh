#!/usr/bin/env bash
set -euo pipefail

echo "Session 7 setup for Ubuntu in WSL"
echo "This step installs Git, unzip, R, PLINK 1.9, and PLINK 2.0."

if ! grep -qi microsoft /proc/version 2>/dev/null; then
  echo "NOTE: This does not appear to be WSL, but installation can continue on Ubuntu."
fi

sudo apt update
sudo apt install -y software-properties-common git unzip wget curl r-base
sudo add-apt-repository -y universe
sudo apt update
sudo apt install -y plink1.9 plink2

mkdir -p "$HOME/bin"
PLINK19_PATH="$(command -v plink1.9 || true)"
if [ -z "$PLINK19_PATH" ] && [ -x /usr/lib/debian-med/bin/plink1.9 ]; then
  PLINK19_PATH=/usr/lib/debian-med/bin/plink1.9
fi
if [ -z "$PLINK19_PATH" ]; then
  echo "ERROR: PLINK 1.9 was installed but its executable was not found."
  exit 1
fi
ln -sf "$PLINK19_PATH" "$HOME/bin/plink"

if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc"; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$HOME/bin:$PATH"

echo
echo "Installed versions:"
git --version
Rscript --version
plink --version
plink2 --version

echo
echo "SETUP COMPLETE. Close and reopen the WSL terminal before class."
