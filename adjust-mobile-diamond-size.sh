#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

pattern = re.compile(
    r"(\.mobileDiamond\s*\{\s*display:\s*block;\s*position:\s*absolute;\s*top:\s*)50%(;\s*left:\s*50%;\s*width:\s*)78vw(;\s*height:\s*)78vw(;\s*max-width:\s*)420px(;\s*max-height:\s*)420px(;)"
)

new_content, n = pattern.subn(
    r"\g<1>46%\g<2>60vw\g<3>60vw\g<4>320px\g<5>320px\g<6>",
    content,
    count=1
)

if n:
    content = new_content
    print(f"Diamond resized (60vw/320px) and shifted up slightly ({n} match)")
else:
    print("ERROR: mobileDiamond block pattern not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
