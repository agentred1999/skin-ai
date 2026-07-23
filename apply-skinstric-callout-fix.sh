#!/bin/bash
set -e

# 1) Update the callout CSS block in result.module.css
python3 - << 'PYEOF'
import re

path = "src/app/result/result.module.css"
with open(path) as f:
    css = f.read()

old_block_start = css.index(".callout {")
old_block_end = css.index(".optionGallery .dot {")
old_block_end = css.index("}", old_block_end) + 1

new_block = """.connector {
  position: absolute;
  inset: 0;
  width: 260px;
  height: 260px;
  z-index: 2;
  pointer-events: none;
  overflow: visible;
}

.connector line {
  stroke: var(--ink);
  stroke-width: 1;
}

.connector circle {
  fill: var(--paper);
  stroke: var(--ink);
  stroke-width: 1;
}

.callout {
  position: absolute;
  z-index: 2;
  font-size: 11px;
  line-height: 1.5;
  letter-spacing: 0.02em;
  white-space: nowrap;
}

.optionScan .callout {
  left: 222px;
  top: 40px;
  text-align: left;
}

.optionGallery .callout {
  right: 222px;
  top: 178px;
  text-align: right;
}
"""

css = css[:old_block_start] + new_block + css[old_block_end:]
# remove now-unused leadLine/dot rules if any remain
css = re.sub(r"\.leadLine \{[^}]*\}\n\n?", "", css)
css = re.sub(r"\.dot \{[^}]*\}\n\n?", "", css)

with open(path, "w") as f:
    f.write(css)

print("Patched", path)
PYEOF

# 2) Update page.tsx: swap leadLine/dot divs for an SVG connector, positioned precisely
python3 - << 'PYEOF'
path = "src/app/result/page.tsx"
with open(path) as f:
    tsx = f.read()

old_scan = '''          <div className={styles.callout}>
            <div className={styles.leadLine} />
            <div className={styles.dot} />
            ALLOW A.I.
            <br />
            TO SCAN YOUR FACE
          </div>'''

new_scan = '''          <svg className={styles.connector} viewBox="0 0 260 260">
            <line x1="167" y1="99" x2="212" y2="62" />
            <circle cx="212" cy="62" r="3" />
          </svg>
          <div className={styles.callout}>
            ALLOW A.I.
            <br />
            TO SCAN YOUR FACE
          </div>'''

old_gallery = '''          <div className={styles.callout}>
            <div className={styles.leadLine} />
            <div className={styles.dot} />
            ALLOW A.I.
            <br />
            ACCESS GALLERY
          </div>'''

new_gallery = '''          <svg className={styles.connector} viewBox="0 0 260 260">
            <line x1="93" y1="161" x2="48" y2="198" />
            <circle cx="48" cy="198" r="3" />
          </svg>
          <div className={styles.callout}>
            ALLOW A.I.
            <br />
            ACCESS GALLERY
          </div>'''

assert old_scan in tsx, "scan callout block not found — check page.tsx manually"
assert old_gallery in tsx, "gallery callout block not found — check page.tsx manually"

tsx = tsx.replace(old_scan, new_scan)
tsx = tsx.replace(old_gallery, new_gallery)

with open(path, "w") as f:
    f.write(tsx)

print("Patched", path)
PYEOF

echo "Done. Refresh localhost:3000/result"
