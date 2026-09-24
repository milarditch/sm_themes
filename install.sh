#!/bin/sh
# Installs the sm_dark_full and sm_powershell themes for VS Code.
# Usage: curl -fsSL https://raw.githubusercontent.com/milarditch/sm_themes/main/install.sh | sh

set -e

VSIX_URL="https://github.com/milarditch/sm_themes/releases/download/latest/sm-themes.vsix"
EXT_DIR="$HOME/.vscode/extensions"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! command -v code >/dev/null 2>&1; then
    echo 'The "code" command was not found. Install VS Code and add it to PATH.' >&2
    exit 1
fi

# Remove copies from older versions of this script
rm -rf "$EXT_DIR/milarditch.minimal-contrast" "$EXT_DIR/milarditch.vscode-theme-dark"
if code --list-extensions | grep -qi '^milarditch\.simple-themes$'; then
    code --uninstall-extension milarditch.simple-themes >/dev/null
fi

echo "Downloading sm_dark_full and sm_powershell..."
curl -fsSL "$VSIX_URL" -o "$TMP/sm-themes.vsix"
code --install-extension "$TMP/sm-themes.vsix" --force

echo "Restart VS Code, press Ctrl+K Ctrl+T and select \"sm_dark_full\" or \"sm_powershell\"."
