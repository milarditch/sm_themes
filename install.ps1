# Installs the sm_dark_full and sm_powershell themes for VS Code.
# Usage: irm https://raw.githubusercontent.com/milarditch/vscode-theme-dark/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$repoZip = 'https://github.com/milarditch/vscode-theme-dark/archive/refs/heads/main.zip'
$extDir  = Join-Path $env:USERPROFILE '.vscode\extensions'
$target  = Join-Path $extDir 'milarditch.vscode-theme-dark'
$tmp     = Join-Path ([IO.Path]::GetTempPath()) ('vscode-theme-dark-' + [guid]::NewGuid())

New-Item -ItemType Directory -Force $tmp | Out-Null
New-Item -ItemType Directory -Force $extDir | Out-Null

try {
    Write-Host 'Downloading sm_dark_full and sm_powershell...'
    $zip = Join-Path $tmp 'theme.zip'
    Invoke-WebRequest -Uri $repoZip -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $tmp -Force

    foreach ($old in @($target, (Join-Path $extDir 'milarditch.minimal-contrast'))) {
        if (Test-Path $old) { Remove-Item -Recurse -Force $old }
    }
    Move-Item (Join-Path $tmp 'vscode-theme-dark-main') $target

    Write-Host "Installed to $target"
    Write-Host 'Restart VS Code, press Ctrl+K Ctrl+T and select "sm_dark_full" or "sm_powershell".'
}
finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
