#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old = "width: 58vw;\n    height: 58vw;\n    max-width: 320px;\n    max-height: 320px;"
new = "width: 71vw;\n    height: 71vw;\n    max-width: 460px;\n    max-height: 460px;"

if old in content:
    content = content.replace(old, new)
    print("Diamond resized to touch nav edges (71vw / 460px)")
else:
    print("ERROR: expected size values not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
