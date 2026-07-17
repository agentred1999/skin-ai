#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

pattern = re.compile(
    r"\.sideAction:hover \.diamond \{\s*background-color:\s*var\(--color-black\);\s*color:\s*var\(--color-white\);\s*transform:\s*rotate\(45deg\) scale\(1\.08\);\s*\}",
    re.DOTALL
)

new_rule = """.sideAction:hover .diamond {
  border-color: var(--color-black);
  transform: rotate(45deg) scale(1.08);
}"""

new_content, n = pattern.subn(new_rule, content, count=1)
if n:
    content = new_content
    print(f"Removed instant black fill from hover state ({n} match)")
else:
    print("ERROR: expected hover rule not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
