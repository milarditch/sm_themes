# sm_themes

## Install

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/milarditch/sm_themes/main/install.ps1 | iex
```

macOS or Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/milarditch/sm_themes/main/install.sh | sh
```

Restart VS Code, press `Ctrl+K Ctrl+T` and select "sm_dark_full", "sm_powershell" or "sm_dark_black_white".
To update, run the same command again.

## Showcase

### sm_dark_full

![sm_dark_full](images/sm_dark_full.png)

### sm_powershell

![sm_powershell](images/sm_powershell.png)

### sm_dark_black_white

![sm_dark_black_white](images/sm_dark_black_white.png)

## Recommended settings

```json
"editor.semanticHighlighting.enabled": true,
"C_Cpp.enhancedColorization": "enabled",
"editor.bracketPairColorization.enabled": false
```
