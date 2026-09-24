# Installs the Minimal Contrast theme for VS Code.
# Usage: irm https://raw.githubusercontent.com/milarditch/vscode-theme-dark/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$repoZip = 'https://github.com/milarditch/vscode-theme-dark/archive/refs/heads/main.zip'
$extDir  = Join-Path $env:USERPROFILE '.vscode\extensions'
$target  = Join-Path $extDir 'milarditch.minimal-contrast'
$tmp     = Join-Path ([IO.Path]::GetTempPath()) ('minimal-contrast-' + [guid]::NewGuid())

New-Item -ItemType Directory -Force $tmp | Out-Null
New-Item -ItemType Directory -Force $extDir | Out-Null

try {
    Write-Host 'Downloading Minimal Contrast...'
    $zip = Join-Path $tmp 'theme.zip'
    Invoke-WebRequest -Uri $repoZip -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $tmp -Force

    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Move-Item (Join-Path $tmp 'vscode-theme-dark-main') $target

    Write-Host "Installed to $target"
    Write-Host 'Restart VS Code, press Ctrl+K Ctrl+T and select "Minimal Contrast".'
}
finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
