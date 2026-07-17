#!/bin/bash
set -e

TSX_FILE="src/app/page.tsx"
CSS_FILE="src/app/page.module.css"

python3 - "$TSX_FILE" "$CSS_FILE" <<'PYEOF'
import sys

tsx_path, css_path = sys.argv[1], sys.argv[2]

with open(tsx_path, "r") as f:
    tsx = f.read()

old = '''        <Link href="/testing" className={styles.enterExperience}>'''
new = '''        <p className={styles.mobileSubtext}>
          Skinstric developed an A.I. that creates a highly-personalized
          routine tailored to what your skin needs.
        </p>

        <Link href="/testing" className={styles.enterExperience}>'''

if "mobileSubtext" not in tsx:
    if old in tsx:
        tsx = tsx.replace(old, new, 1)
        print("page.tsx: mobileSubtext paragraph added")
    else:
        print("ERROR: enterExperience Link not found in page.tsx")
        sys.exit(1)
else:
    print("page.tsx: mobileSubtext already present, skipping")

with open(tsx_path, "w") as f:
    f.write(tsx)

with open(css_path, "r") as f:
    css = f.read()

if ".mobileSubtext" not in css:
    css += """

.mobileSubtext {
  display: none;
}

@media (max-width: 640px) {
  .mobileSubtext {
    display: block;
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.02em;
    color: var(--color-black);
    max-width: 260px;
    line-height: 1.6;
    margin: 0.75rem 0 1.25rem;
    position: relative;
    z-index: 2;
    text-align: center;
  }

  .footer {
    display: none;
  }
}
"""
    print("page.module.css: mobileSubtext style + footer hide-on-mobile added")
else:
    print("page.module.css: .mobileSubtext already present, skipping")

with open(css_path, "w") as f:
    f.write(css)
PYEOF

echo "Done. Review with: git diff $TSX_FILE $CSS_FILE"
