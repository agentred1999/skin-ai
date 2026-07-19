#!/bin/bash
set -

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

changed = False

# 1. Smoother diamond hover: fill + border color transition + slight scale
pattern1 = re.compile(
    r"\.diamond\s*\{[^}]*\}",
    re.DOTALL
)
new_diamond = """.diamond {
  width: 44px;
  height: 44px;
  border: 1px solid var(--color-black);
  transform: rotate(45deg);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: background-color 0.25s ease, border-color 0.25s ease, transform 0.25s ease;
}"""
content, n1 = pattern1.subn(new_diamond, content, count=1)
if n1:
    changed = True
    print("Updated .diamond transition")

# 2. Add scale-up on hover for the side nav diamond
pattern2 = re.compile(
    r"\.sideAction:hover \.diamond\s*\{[^}]*\}",
    re.DOTALL
)
new_hover = """.sideAction:hover .diamond {
  background-color: var(--color-black);
  color: var(--color-white);
  transform: rotate(45deg) scale(1.08);
}"""
content, n2 = pattern2.subn(new_hover, content, count=1)
if n2:
    changed = True
    print("Updated .sideAction:hover .diamond with scale effect")

# 3. Add hover lift to enterCodeButton
pattern3 = re.compile(
    r"\.enterCodeButton\s*\{[^}]*\}",
    re.DOTALL
)
new_button = """.enterCodeButton {
  padding: 0.7rem 1.35rem;
  border-radius: 999px;
  background-color: var(--color-black);
  color: var(--color-white);
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  transition: opacity 0.2s ease, transform 0.2s ease;
}"""
content, n3 = pattern3.subn(new_button, content, count=1)
if n3:
    changed = True
    print("Updated .enterCodeButton transition")

pattern4 = re.compile(
    r"\.enterCodeButton:hover\s*\{[^}]*\}",
    re.DOTALL
)
new_button_hover = """.enterCodeButton:hover {
  opacity: 0.8;
  transform: translateY(-2px);
}"""
content, n4 = pattern4.subn(new_button_hover, content, count=1)
if n4:
    changed = True
    print("Updated .enterCodeButton:hover with lift effect")

if not changed:
    print("ERROR: no target rules found — no changes applied")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
