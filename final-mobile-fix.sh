#!/bin/bash
set -e

TSX_FILE="src/app/page.tsx"
CSS_FILE="src/app/page.module.css"

python3 - "$TSX_FILE" "$CSS_FILE" <<'PYEOF'
import re, sys

tsx_path, css_path = sys.argv[1], sys.argv[2]

with open(tsx_path, "r") as f:
    tsx = f.read()

if "mobileDiamond" not in tsx:
    old = "      <main className={styles.main}>\n"
    new = "      <main className={styles.main}>\n        <div className={styles.mobileDiamond} />\n"
    if old in tsx:
        tsx = tsx.replace(old, new, 1)
        print("page.tsx: mobileDiamond div added")
    else:
        print("WARNING: <main> line not found for mobileDiamond insert")

if "Enter Experience" not in tsx:
    old = '''        <Link href="/testing" className={`${styles.sideAction} ${styles.left}`}>'''
    new = '''        <Link href="/testing" className={styles.enterExperience}>
          Enter Experience
          <span className={styles.enterExperienceIcon}>&#9654;</span>
        </Link>

        <Link href="/testing" className={`${styles.sideAction} ${styles.left}`}>'''
    if old in tsx:
        tsx = tsx.replace(old, new, 1)
        print("page.tsx: Enter Experience link added")
    else:
        print("WARNING: sideAction left Link not found for Enter Experience insert")

with open(tsx_path, "w") as f:
    f.write(tsx)

with open(css_path, "r") as f:
    css = f.read()

if ".mobileDiamond" not in css:
    css += """

.mobileDiamond {
  display: none;
}

.enterExperience {
  display: none;
}

@media (max-width: 640px) {
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
    display: none;
  }

  .enterExperience {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    margin-top: 1.5rem;
    font-size: 0.7rem;
    font-weight: 700;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    z-index: 2;
    position: relative;
  }

  .enterExperienceIcon {
    width: 28px;
    height: 28px;
    border: 1px solid var(--color-black);
    transform: rotate(45deg);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.6rem;
  }

  .enterExperienceIcon span {
    transform: rotate(-45deg);
  }
}
"""
    print("page.module.css: mobileDiamond + enterExperience styles appended")
else:
    print("WARNING: .mobileDiamond already present in CSS, skipping append")

with open(css_path, "w") as f:
    f.write(css)
PYEOF

echo "Done. Review with: git diff $TSX_FILE $CSS_FILE"
