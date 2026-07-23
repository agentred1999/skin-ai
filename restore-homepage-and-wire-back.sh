#!/bin/bash
set -e

echo "Restoring your real homepage from GitHub main..."
curl -sf "https://raw.githubusercontent.com/agentred1999/skin-ai/main/src/app/page.tsx" -o src/app/page.tsx
curl -sf "https://raw.githubusercontent.com/agentred1999/skin-ai/main/src/app/page.module.css" -o src/app/page.module.css
echo "Restored page.tsx and page.module.css"

echo "Wiring the /result BACK button..."
python3 - << 'PYEOF'
path = "src/app/result/page.tsx"
with open(path) as f:
    tsx = f.read()

old_footer = '''      <div className={styles.footer}>
        <div className={styles.backDiamond}>
          <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
            <path d="M15 5 L8 12 L15 19" />
          </svg>
        </div>
        <div className={styles.backLabel}>BACK</div>
      </div>'''

new_footer = '''      <button className={styles.footer} onClick={() => router.push("/")}>
        <div className={styles.backDiamond}>
          <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
            <path d="M15 5 L8 12 L15 19" />
          </svg>
        </div>
        <div className={styles.backLabel}>BACK</div>
      </button>'''

if old_footer in tsx:
    tsx = tsx.replace(old_footer, new_footer)
    with open(path, "w") as f:
        f.write(tsx)
    print("BACK button now routes to /")
elif 'onClick={() => router.push("/")}' in tsx and "BACK" in tsx:
    print("BACK button already wired — nothing to do.")
else:
    print("Footer markup didn't match exactly — paste me the current footer JSX and I'll fix it directly.")
PYEOF

echo "Done."
