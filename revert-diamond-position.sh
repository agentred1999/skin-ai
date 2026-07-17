#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old = """  .mobileDiamond {
    display: block;
    position: absolute;
    top: 40%;
    left: 50%;
    width: 58vw;
    height: 58vw;
    max-width: 320px;
    max-height: 320px;"""

new = """  .mobileDiamond {
    display: block;
    position: absolute;
    top: 44%;
    left: 50%;
    width: 48vw;
    height: 48vw;
    max-width: 260px;
    max-height: 260px;"""

if old in content:
    content = content.replace(old, new)
    print("Reverted diamond back to top:44% / 48vw / 260px")
else:
    print("ERROR: expected block not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
