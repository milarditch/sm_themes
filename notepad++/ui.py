"""Apply a flat, modern UI setup to the Notepad++ config.xml.

Close Notepad++ before you run this script. Notepad++ writes config.xml again when it closes.
"""
import os, re
from pathlib import Path

CFG = Path(os.environ["APPDATA"]) / "Notepad++" / "config.xml"

CHANGES = {
    "ToolBar": {"fluentMono": "yes", "_text": "small"},
    "TabBar": {"drawTopBar": "yes", "drawInactiveTab": "no", "reduce": "yes",
               "closeButton": "yes", "pinButton": "no", "buttonsOninactiveTabs": "no"},
    "MISC": {"hideMenuRightShortcuts": "yes"},
    "DarkMode": {"lightToolBarIconSet": "0", "lightTbFluentMono": "yes", "lightTabIconSet": "2",
                 "darkToolBarIconSet": "0", "darkTbFluentMono": "yes", "darkTabUseTheme": "yes"},
    "ScintillaPrimaryView": {"borderEdge": "no", "borderWidth": "0", "bookMarkMargin": "hide",
                             "indentGuideLine": "hide", "folderMarkStyle": "simple",
                             "currentLineIndicator": "2", "currentLineFrameWidth": "1",
                             "paddingLeft": "6", "isChangeHistoryEnabled": "0",
                             "disableSelectedTextDragDrop": "yes"},
}

text = CFG.read_text(encoding="utf-8")
for name, attrs in CHANGES.items():
    m = re.search(rf'<GUIConfig name="{name}"[^>]*?(/?)>', text)
    tag = m.group(0)
    new = tag
    for k, v in attrs.items():
        if k == "_text":
            continue
        if re.search(rf' {k}="', new):
            new = re.sub(rf' {k}="[^"]*"', f' {k}="{v}"', new)
        else:
            new = new.replace(f'name="{name}"', f'name="{name}" {k}="{v}"')
    text = text.replace(tag, new)
    if "_text" in attrs:
        text = re.sub(rf'(<GUIConfig name="{name}"[^>]*>)[^<]*(</GUIConfig>)',
                      rf'\g<1>{attrs["_text"]}\g<2>', text)
CFG.write_text(text, encoding="utf-8")
print("updated", CFG)
