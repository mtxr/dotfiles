#!/bin/bash
# Install Nix via the Determinate installer. No-op once Nix is present.
# Uninstall: /nix/nix-installer uninstall
set -euo pipefail

if [[ -x /nix/var/nix/profiles/default/bin/nix ]]; then
  echo "✅ Nix is already installed!"
  exit 0
fi

echo "🔄 Installing Nix (Determinate installer, needs sudo)..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
echo "✅ Nix installed!"
