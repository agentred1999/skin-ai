#!/bin/bash
set -e

CSS_FILE="src/app/globals.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

pattern = re.compile(
    r"\.corner-diamond\s*\{.*?\.corner-diamond\.bottom-right\s*\{[^}]*\}",
    re.DOTALL
)

new_block = """.corner-diamond {
  position: fixed;
  width: 602px;
  height: 602px;
  border: 2px dashed #A0A4AB;
  transform: rotate(45deg);
  pointer-events: none;
  z-index: 0;
  top: 50%;
  margin-top: -301px;
}
.corner-diamond.top-left,
.corner-diamond.bottom-left {
  left: -301px;
}
.corner-diamond.top-right,
.corner-diamond.bottom-right {
  right: -301px;
}
.corner-diamond.bottom-left,
.corner-diamond.bottom-right {
  display: none;
}"""

new_content, n = pattern.subn(new_block, content, count=1)
if n:
    content = new_content
    print(f"Replaced corner-diamond block ({n} match) with Figma-accurate two-diamond spec")
else:
    print("ERROR: corner-diamond block pattern not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
