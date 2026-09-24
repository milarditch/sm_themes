# Minimal Contrast

## Install

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/milarditch/vscode-theme-dark/main/install.ps1 | iex
```

macOS or Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/milarditch/vscode-theme-dark/main/install.sh | sh
```

Restart VS Code, press `Ctrl+K Ctrl+T` and select "sm_dark_full" or "sm_powershell".
To update, run the same command again.

<!-- Add a screenshot: ![Minimal Contrast](images/screenshot.png) -->

## Colors

| Item | Color |
|---|---|
| Keywords, built-in types, preprocessor directives | `#E8453C` red |
| Types: struct, class, enum, union, typedef | `#FFD700` gold |
| Functions and methods | `#FF8000` orange |
| Macros | `#BD63C5` purple |
| Enum members | `#D0904A` brown orange |
| Variables, parameters and fields | `#BDB76B` khaki |
| Numbers | `#B5CEA8` light green |
| Strings and characters | `#D69D85` light brown |
| Comments | `#57A64A` green |
| Operators | `#FFFFFF` white |
| Namespaces | `#DCDCDC` italic |

The UI is black with dark gray borders. The active tab has a gray background
and a gray line at the top.

## Recommended settings

```json
"editor.semanticHighlighting.enabled": true,
"C_Cpp.enhancedColorization": "enabled",
"editor.bracketPairColorization.enabled": false
```
