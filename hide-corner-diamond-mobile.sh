#!/bin/bash
set -e

CSS_FILE="src/app/globals.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

pattern = re.compile(
    r"@media\s*\(max-width:\s*640px\)\s*\{\s*\.corner-diamond\s*\{[^}]*\}.*?\n\}",
    re.DOTALL
)

new_block = "@media (max-width: 640px) {\n  .corner-diamond {\n    display: none;\n  }\n}"

new_content, n = pattern.subn(new_block, content, count=1)
if n:
    content = new_content
    print(f"Hid .corner-diamond under 640px ({n} match)")
else:
    print("ERROR: mobile corner-diamond media block not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
