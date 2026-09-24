#!/bin/sh
# Installs the Minimal Contrast theme for VS Code.
# Usage: curl -fsSL https://raw.githubusercontent.com/milarditch/vscode-theme-dark/main/install.sh | sh

set -e

REPO_TAR="https://github.com/milarditch/vscode-theme-dark/archive/refs/heads/main.tar.gz"
EXT_DIR="$HOME/.vscode/extensions"
TARGET="$EXT_DIR/milarditch.minimal-contrast"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$EXT_DIR"

echo "Downloading Minimal Contrast..."
curl -fsSL "$REPO_TAR" | tar -xz -C "$TMP"

rm -rf "$TARGET"
mv "$TMP/vscode-theme-dark-main" "$TARGET"

echo "Installed to $TARGET"
echo "Restart VS Code, press Ctrl+K Ctrl+T and select \"Minimal Contrast\"."
