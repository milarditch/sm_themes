# Installs the sm_dark_full and sm_powershell themes for VS Code.
# Usage: irm https://raw.githubusercontent.com/milarditch/sm_themes/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$vsixUrl = 'https://github.com/milarditch/sm_themes/releases/download/latest/simple-themes.vsix'
$extDir  = Join-Path $env:USERPROFILE '.vscode\extensions'
$vsix    = Join-Path ([IO.Path]::GetTempPath()) 'simple-themes.vsix'

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    throw 'The "code" command was not found. Install VS Code and add it to PATH.'
}

# Remove copies from older versions of this script
foreach ($old in 'milarditch.minimal-contrast', 'milarditch.vscode-theme-dark') {
    $path = Join-Path $extDir $old
    if (Test-Path $path) { Remove-Item -Recurse -Force $path }
}

try {
    Write-Host 'Downloading sm_dark_full and sm_powershell...'
    Invoke-WebRequest -Uri $vsixUrl -OutFile $vsix -UseBasicParsing
    code --install-extension $vsix --force
    if ($LASTEXITCODE -ne 0) { throw 'The installation failed.' }

    Write-Host 'Restart VS Code, press Ctrl+K Ctrl+T and select "sm_dark_full" or "sm_powershell".'
}
finally {
    Remove-Item -Force $vsix -ErrorAction SilentlyContinue
}
