#!/bin/bash
set -e

CSS_FILE="src/app/globals.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

pattern = re.compile(
    r"\.corner-diamond\s*\{.*?\.corner-diamond\.bottom-left,\s*\n\.corner-diamond\.bottom-right\s*\{[^}]*\}",
    re.DOTALL
)

new_block = """.corner-diamond {
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

new_content, n = pattern.subn(new_block, content, count=1)
if n:
    content = new_content
    print(f"Reverted to original four-corner X-pattern ({n} match)")
else:
    print("ERROR: pattern not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
