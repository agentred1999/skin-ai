#!/bin/bash
set -e

CSS_FILE="src/app/globals.css"

python3 - "$CSS_FILE" <<'PYEOF'
import sys
path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old_block = """.corner-diamond {
  position: fixed;
  width: 620px;
  height: 620px;
  border: 1px solid rgba(0, 0, 0, 0.12);
  transform: rotate(-45deg);
  pointer-events: none;
  z-index: 0;
}
.corner-diamond.top-left {
  top: -310px;
  left: -310px;
}
.corner-diamond.top-right {
  top: -310px;
  right: -310px;
}
.corner-diamond.bottom-left {
  bottom: -310px;
  left: -310px;
}
.corner-diamond.bottom-right {
  bottom: -310px;
  right: -310px;
}"""

new_block = """.corner-diamond {
  position: fixed;
  width: 90vmax;
  height: 90vmax;
  border: 1px solid rgba(0, 0, 0, 0.12);
  transform: rotate(-45deg);
  pointer-events: none;
  z-index: 0;
}
.corner-diamond.top-left {
  top: -45vmax;
  left: -45vmax;
}
.corner-diamond.top-right {
  top: -45vmax;
  right: -45vmax;
}
.corner-diamond.bottom-left {
  bottom: -45vmax;
  left: -45vmax;
}
.corner-diamond.bottom-right {
  bottom: -45vmax;
  right: -45vmax;
}"""

if old_block in content:
    content = content.replace(old_block, new_block)
    print("Updated .corner-diamond to use vmax sizing")
else:
    print("WARNING: block not found exactly as expected — no change made. Paste your current globals.css .corner-diamond section and I'll adjust the script.")

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
