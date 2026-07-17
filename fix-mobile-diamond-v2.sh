#!/bin/bash
set -e

CSS_FILE="src/app/globals.css"

python3 - "$CSS_FILE" <<'PYEOF'
import sys
path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old = """@media (max-width: 640px) {
  .corner-diamond {
    width: 400px;
    height: 400px;
  }
  .corner-diamond.top-left,
  .corner-diamond.bottom-left {
    left: -200px;
  }
  .corner-diamond.top-right,
  .corner-diamond.bottom-right {
    right: -200px;
  }
  .corner-diamond.top-left,
  .corner-diamond.top-right {
    top: -200px;
  }
  .corner-diamond.bottom-left,
  .corner-diamond.bottom-right {
    bottom: -200px;
  }
}"""

new = """@media (max-width: 640px) {
  .corner-diamond {
    display: none;
  }
}"""

if old in content:
    content = content.replace(old, new)
    print("globals.css: corner-diamond X-lines now hidden below 640px")
else:
    print("ERROR: exact block not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
