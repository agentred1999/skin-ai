#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

if ".sideAction {" in content or ".sideAction{" in content:
    print("WARNING: .sideAction base rule already exists somewhere, skipping to avoid duplicates")
else:
    addition = """
.sideAction {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  gap: 0.85rem;
  z-index: 2;
}

.sideAction.left {
  left: 1.5rem;
}

.sideAction.right {
  right: 1.5rem;
  flex-direction: row-reverse;
}

.diamond {
  width: 44px;
  height: 44px;
  border: 1px solid var(--color-black);
  transform: rotate(45deg);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: background-color 0.2s ease;
}

.diamond span {
  display: inline-block;
  transform: rotate(-45deg);
  font-size: 0.7rem;
}

.sideAction:hover .diamond {
  background-color: var(--color-black);
  color: var(--color-white);
}

.sideActionLabel {
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  white-space: nowrap;
}
"""
    content = addition + "\n" + content
    with open(path, "w") as f:
        f.write(content)
    print(".sideAction base rules added")
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
