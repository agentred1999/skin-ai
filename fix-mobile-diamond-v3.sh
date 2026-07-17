#!/bin/bash
set -e

CSS_FILE="src/app/page.module.css"

python3 - "$CSS_FILE" <<'PYEOF'
import sys
path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old = """@media (max-width: 768px) {
  .page {
    padding: 1.5rem;
  }
  .sideAction.left,
  .sideAction.right {
    position: static;
    transform: none;
    margin-top: 2rem;
  }
  .main {
    flex-direction: column;
    gap: 1.5rem;
  }
}"""

new = """.mobileDiamond {
  display: none;
}
@media (max-width: 768px) {
  .page {
    padding: 1.5rem;
  }
  .mobileDiamond {
    display: block;
    position: absolute;
    top: 50%;
    left: 50%;
    width: 78vw;
    height: 78vw;
    max-width: 420px;
    max-height: 420px;
    border: 1px solid rgba(0, 0, 0, 0.15);
    transform: translate(-50%, -50%) rotate(45deg);
    pointer-events: none;
    z-index: 0;
  }
  .sideAction.left,
  .sideAction.right {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    margin-top: 0;
  }
  .sideAction.left {
    left: 0;
  }
  .sideAction.right {
    right: 0;
  }
  .main {
    flex-direction: column;
    gap: 1.5rem;
  }
}"""

if old in content:
    content = content.replace(old, new)
    print("page.module.css: mobile diamond + repositioned nav points added")
else:
    print("ERROR: exact block not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $CSS_FILE"
