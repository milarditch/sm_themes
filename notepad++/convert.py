"""Convert the sm VS Code themes to Notepad++ themes."""
import json, re, sys, xml.etree.ElementTree as ET
from pathlib import Path

SRC = Path(__file__).resolve().parent.parent / "themes"
MODEL = Path(r"C:\Program Files\Notepad++\stylers.model.xml")
OUT = Path(__file__).resolve().parent / "themes"
FONT = "0xProto Nerd Font Mono"

def load(p):
    t = re.sub(r"^\s*//.*$", "", p.read_text(encoding="utf-8"), flags=re.M)
    return json.loads(re.sub(r",(\s*[}\]])", r"\1", t))

def hx(c):
    return c.lstrip("#")[:6].upper()

def scope_color(theme, scope):
    for rule in theme["tokenColors"]:
        s = rule["scope"]; s = [s] if isinstance(s, str) else s
        if scope in s and "foreground" in rule["settings"]:
            return hx(rule["settings"]["foreground"])

def sem(theme, key):
    v = theme["semanticTokenColors"][key]
    return hx(v if isinstance(v, str) else v["foreground"])

def palette(t):
    c = t["colors"]
    return {
        "bg": hx(c["editor.background"]), "fg": hx(c["editor.foreground"]),
        "keyword": scope_color(t, "keyword"), "string": scope_color(t, "string"),
        "comment": scope_color(t, "comment"), "number": sem(t, "number"),
        "type": sem(t, "type"), "function": sem(t, "function"),
        "macro": sem(t, "macro"), "variable": sem(t, "variable"),
        "constant": sem(t, "enumMember"), "operator": sem(t, "operator"),
        "panel": hx(c["menu.background"]), "border": hx(c["editorWidget.border"]),
        "line": hx(c["editor.lineHighlightBorder"]), "sel": hx(c["list.activeSelectionBackground"]),
        "accent": hx(c["tab.activeBorderTop"]), "match": hx(c["list.highlightForeground"]),
        "muted": hx(c["tab.inactiveForeground"]), "tabfg": hx(c["tab.activeForeground"]),
        "tabbg": hx(c["tab.inactiveBackground"]),
    }

# Order matters: the first matching rule wins.
RULES = [
    ("comment", r"COMMENT|DOC|POD"),
    ("string", r"STRING|CHARACTER|CHAR\b|VERBATIM|QUOTED|HEREDOC|REGEX|BACKTICK|TEMPLATE|LITERAL|CDATA|ATTRIBUTE VALUE|VALUE"),
    ("number", r"NUMBER|NUMERIC|HEX|FLOAT|INTEGER|DIGIT"),
    ("macro", r"PREPROCESSOR|DIRECTIVE|MACRO|PRAGMA|DECORATOR|ANNOTATION|DEFINE|INCLUDE"),
    ("type", r"TYPE|CLASS|bSTRUCT|ENUM|INTERFACE|NAMESPACE|MODULE|TAG\b|SECTION|ELEMENT|PACKAGE"),
    ("function", r"FUNCTION|METHOD|CMDLET|COMMAND|BUILTIN|PROCEDURE|ATTRIBUTE|PROPERTY"),
    ("keyword", r"KEYWORD|INSTRUCTION|WORD|STATEMENT|RESERVED|RULE|DECLARATION"),
    ("variable", r"VARIABLE|PARAMETER|IDENTIFIER|KEY\b|FIELD|LABEL|SYMBOL|GLOBAL"),
    ("constant", r"CONSTANT|BOOLEAN|SPECIAL|ENTITY"),
    ("operator", r"OPERATOR|DELIMITER|PUNCTUATION|BRACE|BRACKET|SEPARATOR"),
    ("error", r"ERROR|ILLEGAL|BAD|GARBAGE|UNKNOWN|WRONG|UNCLOSED|EOL"),
]

def role(name):
    for r, pat in RULES:
        if re.search(pat, name.upper()):
            return r
    return "fg"

def convert(src):
    t = load(src); p = palette(t)
    p["error"] = p["keyword"]
    tree = ET.parse(MODEL); root = tree.getroot()
    for ws in root.iter("WordsStyle"):
        ws.set("fgColor", p[role(ws.get("name"))])
        ws.set("bgColor", p["bg"])
        ws.set("fontStyle", "0")
    g = {
        "Default Style": dict(fgColor=p["fg"], bgColor=p["bg"], fontName=FONT, fontSize="12"),
        "Indent guideline style": dict(fgColor=p["border"], bgColor=p["bg"]),
        "Brace highlight style": dict(fgColor=p["match"], bgColor=p["sel"]),
        "Bad brace colour": dict(fgColor=p["keyword"], bgColor=p["bg"]),
        "Current line background colour": dict(bgColor=p["line"]),
        "Selected text colour": dict(bgColor=p["sel"], fgColor=p["tabfg"]),
        "Multi-selected text color": dict(bgColor=p["sel"]),
        "Caret colour": dict(fgColor=p["tabfg"]),
        "Multi-edit carets color": dict(fgColor=p["muted"]),
        "Edge colour": dict(fgColor=p["border"]),
        "Line number margin": dict(fgColor=p["muted"], bgColor=p["bg"]),
        "Bookmark margin": dict(bgColor=p["bg"]),
        "Change History margin": dict(bgColor=p["bg"]),
        "Fold": dict(fgColor=p["muted"], bgColor=p["bg"]),
        "Fold active": dict(fgColor=p["accent"]),
        "Fold margin": dict(fgColor=p["bg"], bgColor=p["bg"]),
        "White space symbol": dict(fgColor=p["border"]),
        "Smart Highlighting": dict(bgColor=p["sel"]),
        "Find Mark Style": dict(bgColor=p["sel"]),
        "Incremental highlight all": dict(bgColor=p["sel"]),
        "Tags match highlighting": dict(bgColor=p["sel"]),
        "Tags attribute": dict(bgColor=p["panel"]),
        "Active tab focused indicator": dict(fgColor=p["accent"]),
        "Active tab unfocused indicator": dict(fgColor=p["border"]),
        "Active tab text": dict(fgColor=p["tabfg"]),
        "Inactive tabs": dict(fgColor=p["muted"], bgColor=p["tabbg"]),
        "URL hovered": dict(fgColor=p["match"]),
        "Document map": dict(fgColor=p["accent"], bgColor=p["bg"]),
        "EOL custom color": dict(fgColor=p["border"]),
        "Non-printing characters custom color": dict(fgColor=p["border"]),
    }
    for w in root.iter("WidgetStyle"):
        for k, v in g.get(w.get("name"), {}).items():
            w.set(k, v)
    OUT.mkdir(exist_ok=True)
    dst = OUT / f"{t['name']}.xml"
    tree.write(dst, encoding="UTF-8", xml_declaration=True)
    print(dst)

for f in sorted(SRC.glob("*.json")):
    convert(f)
