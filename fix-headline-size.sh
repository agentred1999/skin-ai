#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

pattern = re.compile(r"\.headline\s*\{[^}]*\}", re.DOTALL)

new_block = """.headline {
  font-size: clamp(2.5rem, 8vw, 8rem);
  font-weight: 300;
  line-height: 0.9375;
  letter-spacing: -0.07em;
  max-width: 680px;
}"""

new_content, n = pattern.subn(new_block, content, count=1)
if n:
    content = new_content
    print(f"Headline updated to match Figma spec ({n} match)")
else:
    print("ERROR: .headline block not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
