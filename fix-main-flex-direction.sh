#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old = """.main {
  position: relative;
  z-index: 2;
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}"""

new = """.main {
  position: relative;
  z-index: 2;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}"""

if old in content:
    content = content.replace(old, new)
    print("Fixed .main: added flex-direction: column")
else:
    print("ERROR: expected .main block not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
