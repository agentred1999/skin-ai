#!/bin/bash
set -e

TSX_FILE="src/app/page.tsx"
CSS_FILE="src/app/page.module.css"

python3 - "$TSX_FILE" "$CSS_FILE" <<'PYEOF'
import sys

tsx_path, css_path = sys.argv[1], sys.argv[2]

with open(tsx_path, "r") as f:
    tsx = f.read()

old = '        <div className={styles.mobileDiamond} />\n'
new = (
    '        <div className={styles.mobileDiamond} />\n'
    '        <div className={styles.mobileDiamondInner} />\n'
)

if old in tsx and "mobileDiamondInner" not in tsx:
    tsx = tsx.replace(old, new, 1)
    print("page.tsx: mobileDiamondInner div added")
elif "mobileDiamondInner" in tsx:
    print("page.tsx: mobileDiamondInner already present, skipping")
else:
    print("ERROR: mobileDiamond div line not found in page.tsx")
    sys.exit(1)

with open(tsx_path, "w") as f:
    f.write(tsx)

with open(css_path, "r") as f:
    css = f.read()

old_css = """  .mobileDiamond {
    display: block;
    position: absolute;
    top: 44%;
    left: 50%;
    width: 48vw;
    height: 48vw;
    max-width: 260px;
    max-height: 260px;
    border: 1px solid rgba(0, 0, 0, 0.15);
    transform: translate(-50%, -50%) rotate(45deg);
    pointer-events: none;
    z-index: 0;
  }"""

new_css = """  .mobileDiamond {
    display: block;
    position: absolute;
    top: 44%;
    left: 50%;
    width: 48vw;
    height: 48vw;
    max-width: 260px;
    max-height: 260px;
    border: 1px solid rgba(0, 0, 0, 0.15);
    transform: translate(-50%, -50%) rotate(45deg);
    pointer-events: none;
    z-index: 0;
  }

  .mobileDiamondInner {
    display: block;
    position: absolute;
    top: 44%;
    left: 50%;
    width: 38vw;
    height: 38vw;
    max-width: 200px;
    max-height: 200px;
    border: 1px solid rgba(0, 0, 0, 0.15);
    transform: translate(-50%, -50%) rotate(45deg);
    pointer-events: none;
    z-index: 0;
  }"""

if old_css in css:
    css = css.replace(old_css, new_css)
    print("page.module.css: nested inner diamond style added")
else:
    print("ERROR: expected .mobileDiamond CSS block not found")
    sys.exit(1)

with open(css_path, "w") as f:
    f.write(css)
PYEOF

echo "Done. Review with: git diff $TSX_FILE $CSS_FILE"
