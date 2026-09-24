# Installs the sm_dark_full, sm_powershell, sm_dark_black_white and sm_matrix themes for VS Code.
# Usage: irm https://raw.githubusercontent.com/milarditch/sm_themes/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$vsixUrl = 'https://github.com/milarditch/sm_themes/releases/download/latest/sm-themes.vsix'
$vsix    = Join-Path ([IO.Path]::GetTempPath()) 'sm-themes.vsix'

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    throw 'The "code" command was not found. Install VS Code and add it to PATH.'
}

try {
    Write-Host 'Downloading sm_dark_full, sm_powershell, sm_dark_black_white and sm_matrix...'
    Invoke-WebRequest -Uri $vsixUrl -OutFile $vsix -UseBasicParsing
    code --install-extension $vsix --force
    if ($LASTEXITCODE -ne 0) { throw 'The installation failed.' }

    Write-Host 'Restart VS Code, press Ctrl+K Ctrl+T and select "sm_dark_full", "sm_powershell", "sm_dark_black_white" or "sm_matrix".'
}
finally {
    Remove-Item -Force $vsix -ErrorAction SilentlyContinue
}
