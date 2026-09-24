#!/bin/sh
# Installs the sm_dark_full, sm_powershell, sm_dark_black_white, sm_matrix, sm_light and sm_amber themes for VS Code.
# Usage: curl -fsSL https://raw.githubusercontent.com/milarditch/sm_themes/main/install.sh | sh

set -e

VSIX_URL="https://github.com/milarditch/sm_themes/releases/download/latest/sm-themes.vsix"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! command -v code >/dev/null 2>&1; then
    echo 'The "code" command was not found. Install VS Code and add it to PATH.' >&2
    exit 1
fi

echo "Downloading sm_dark_full, sm_powershell, sm_dark_black_white, sm_matrix, sm_light and sm_amber..."
curl -fsSL "$VSIX_URL" -o "$TMP/sm-themes.vsix"
code --install-extension "$TMP/sm-themes.vsix" --force

echo "Restart VS Code, press Ctrl+K Ctrl+T and select \"sm_dark_full\", \"sm_powershell\", \"sm_dark_black_white\", \"sm_matrix\", \"sm_light\" or \"sm_amber\"."
