#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

changed = False

pattern1 = re.compile(
    r"position:\s*static;\s*\n\s*transform:\s*none;\s*\n\s*margin-top:\s*2rem;"
)
replacement1 = (
    "position: absolute;\n"
    "    top: 50%;\n"
    "    transform: translateY(-50%);\n"
    "    margin-top: 0;\n"
    "  }\n"
    "  .sideAction.left {\n"
    "    left: 0;\n"
    "  }\n"
    "  .sideAction.right {\n"
    "    right: 0;"
)
new_content, n1 = pattern1.subn(replacement1, content)
if n1:
    content = new_content
    changed = True
    print(f"Fixed sideAction mobile positioning ({n1} match)")
else:
    print("WARNING: sideAction static block pattern not found")

if ".mobileDiamond" not in content:
    media_pattern = re.compile(r"(@media\s*\(max-width:\s*768px\)\s*\{)")
    base_rule = ".mobileDiamond {\n  display: none;\n}\n"
    content, n2 = media_pattern.subn(base_rule + r"\1", content, count=1)
    if n2:
        changed = True
        print("Inserted .mobileDiamond base rule before media query")
    else:
        print("WARNING: @media (max-width: 768px) block not found for base rule insertion")

    padding_pattern = re.compile(
        r"(@media\s*\(max-width:\s*768px\)\s*\{\s*\n\s*\.page\s*\{\s*\n\s*padding:\s*1\.5rem;\s*\n\s*\})"
    )
    mobile_rule = (
        "\n  .mobileDiamond {\n"
        "    display: block;\n"
        "    position: absolute;\n"
        "    top: 50%;\n"
        "    left: 50%;\n"
        "    width: 78vw;\n"
        "    height: 78vw;\n"
        "    max-width: 420px;\n"
        "    max-height: 420px;\n"
        "    border: 1px solid rgba(0, 0, 0, 0.15);\n"
        "    transform: translate(-50%, -50%) rotate(45deg);\n"
        "    pointer-events: none;\n"
        "    z-index: 0;\n"
        "  }"
    )
    content, n3 = padding_pattern.subn(r"\1" + mobile_rule, content, count=1)
    if n3:
        changed = True
        print("Inserted .mobileDiamond visible rule inside media query")
    else:
        print("WARNING: .page padding block inside media query not found for mobile rule insertion")

if not changed:
    print("ERROR: no changes applied at all")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)

print("File written successfully")
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
