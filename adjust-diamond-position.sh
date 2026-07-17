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
    top: 44%;
    left: 50%;
    width: 48vw;
    height: 48vw;
    max-width: 260px;
    max-height: 260px;"""

new = """  .mobileDiamond {
    display: block;
    position: absolute;
    top: 40%;
    left: 50%;
    width: 58vw;
    height: 58vw;
    max-width: 320px;
    max-height: 320px;"""

if old in content:
    content = content.replace(old, new)
    print("Diamond repositioned: top 44%->40%, size 48vw->58vw")
else:
    print("ERROR: expected .mobileDiamond block not found")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
