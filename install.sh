#!/bin/sh
# Installs the sm_dark_full and sm_powershell themes for VS Code.
# Usage: curl -fsSL https://raw.githubusercontent.com/milarditch/vscode-theme-dark/main/install.sh | sh

set -e

REPO_TAR="https://github.com/milarditch/vscode-theme-dark/archive/refs/heads/main.tar.gz"
EXT_DIR="$HOME/.vscode/extensions"
TARGET="$EXT_DIR/milarditch.vscode-theme-dark"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$EXT_DIR"

echo "Downloading sm_dark_full and sm_powershell..."
curl -fsSL "$REPO_TAR" | tar -xz -C "$TMP"

rm -rf "$TARGET" "$EXT_DIR/milarditch.minimal-contrast"
mv "$TMP/vscode-theme-dark-main" "$TARGET"

echo "Installed to $TARGET"
echo "Restart VS Code, press Ctrl+K Ctrl+T and select \"sm_dark_full\" or \"sm_powershell\"."
