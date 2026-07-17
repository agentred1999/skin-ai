#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old = "width: 78vw;\n    height: 78vw;\n    max-width: 420px;\n    max-height: 420px;"
new = "width: 58vw;\n    height: 58vw;\n    max-width: 320px;\n    max-height: 320px;"

if old in content:
    content = content.replace(old, new)
    print("Diamond size reduced (78vw/420px -> 58vw/320px)")
else:
    print("ERROR: expected size values not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
