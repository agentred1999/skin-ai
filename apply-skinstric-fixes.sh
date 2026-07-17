#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

if [ ! -f "$CSS_FILE" ]; then
  echo "Error: $CSS_FILE not found. Run this from your project root."
  exit 1
fi

python3 - "$CSS_FILE" <<'PYEOF'
import sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old_logo = """.logo {
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.05em;
}"""

new_logo = """.logo {
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.05em;
  border: 1px solid var(--color-black);
  padding: 0.35rem 0.75rem;
}"""

if old_logo in content:
    content = content.replace(old_logo, new_logo)
    print("Updated .logo with border pill")
else:
    print("WARNING: .logo block not found as expected, skipping")

old_main = """.main {
  position: relative;
  z-index: 2;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}"""

new_main = """.main {
  position: relative;
  z-index: 2;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  padding-bottom: 4rem;
}"""

if old_main in content:
    content = content.replace(old_main, new_main)
    print("Updated .main padding to shift content up")
else:
    print("WARNING: .main block not found as expected, skipping")

old_headline = """.headline {
  font-size: clamp(2.75rem, 7.5vw, 6rem);
  font-weight: 500;
  line-height: 1.05;
  letter-spacing: -0.02em;
  max-width: 900px;
}"""

new_headline = """.headline {
  font-size: clamp(2.75rem, 7.5vw, 6rem);
  font-weight: 400;
  line-height: 1.05;
  letter-spacing: -0.02em;
  max-width: 900px;
}"""

if old_headline in content:
    content = content.replace(old_headline, new_headline)
    print("Updated .headline font-weight to 400")
else:
    print("WARNING: .headline block not found as expected, skipping")

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review the diff with: git diff $CSS_FILE"
