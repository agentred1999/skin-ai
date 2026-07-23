#!/bin/bash
set -e

# ---------- 1) Home page ----------
cat > src/app/page.tsx << 'EOF'
"use client";

import { useRouter } from "next/navigation";
import styles from "./page.module.css";

export default function HomePage() {
  const router = useRouter();

  return (
    <div className={styles.page}>
      <div className={styles.topbar}>
        <div className={styles.brand}>
          <span className={styles.brandMark}>SKINSTRIC</span>
          <span className={styles.brandSub}>[ INTRO ]</span>
        </div>
        <button className={styles.enterCode}>ENTER CODE</button>
      </div>

      <div className={styles.stage}>
        <svg className={styles.crossLines} viewBox="0 0 1920 900" preserveAspectRatio="none">
          <line x1="0" y1="0" x2="1920" y2="900" />
          <line x1="0" y1="900" x2="1920" y2="0" />
        </svg>

        <button
          className={`${styles.navBtn} ${styles.navBtnLeft}`}
          onClick={() => router.push("/discover")}
        >
          <div className={styles.navDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M15 5 L8 12 L15 19" />
            </svg>
          </div>
          <span className={styles.navLabel}>DISCOVER A.I.</span>
        </button>

        <h1 className={styles.headline}>
          Sophisticated
          <br />
          skincare
        </h1>

        <button
          className={`${styles.navBtn} ${styles.navBtnRight}`}
          onClick={() => router.push("/result")}
        >
          <span className={styles.navLabel}>TAKE TEST</span>
          <div className={styles.navDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M9 5 L16 12 L9 19" />
            </svg>
          </div>
        </button>

        <p className={styles.blurb}>
          SKINSTRIC DEVELOPED AN A.I. THAT CREATES A
          <br />
          HIGHLY-PERSONALIZED ROUTINE TAILORED TO
          <br />
          WHAT YOUR SKIN NEEDS.
        </p>
      </div>
    </div>
  );
}
EOF

cat > src/app/page.module.css << 'EOF'
.page {
  --ink: #0d0d0d;
  --line: #e0e0dc;
  --paper: #ffffff;
  --muted: #8a8a85;

  min-height: 100vh;
  background: var(--paper);
  color: var(--ink);
  font-family: "Courier New", Courier, monospace;
  padding: 32px 40px;
  display: flex;
  flex-direction: column;
}

.topbar {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  z-index: 2;
  position: relative;
}

.brand {
  display: flex;
  align-items: center;
  gap: 10px;
}

.brandMark {
  font-weight: 700;
  font-size: 14px;
  letter-spacing: 0.03em;
  border: 1px solid var(--ink);
  padding: 6px 10px;
}

.brandSub {
  font-size: 12px;
  letter-spacing: 0.05em;
  color: var(--muted);
}

.enterCode {
  background: var(--ink);
  color: var(--paper);
  font-family: inherit;
  font-size: 11px;
  letter-spacing: 0.05em;
  border: none;
  padding: 10px 16px;
  cursor: pointer;
}

.stage {
  flex: 1;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.crossLines {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

.crossLines line {
  stroke: var(--line);
  stroke-width: 1;
}

.headline {
  position: relative;
  z-index: 2;
  font-family: Georgia, "Times New Roman", serif;
  font-weight: 400;
  font-size: 64px;
  line-height: 1.15;
  text-align: center;
  margin: 0;
}

.navBtn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  gap: 14px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  font-family: inherit;
  z-index: 2;
}

.navBtnLeft {
  left: 40px;
}

.navBtnRight {
  right: 40px;
}

.navDiamond {
  width: 34px;
  height: 34px;
  border: 1px solid var(--ink);
  transform: rotate(45deg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.navDiamond svg {
  transform: rotate(-45deg);
  width: 14px;
  height: 14px;
}

.navLabel {
  font-size: 12px;
  letter-spacing: 0.04em;
}

.blurb {
  position: absolute;
  left: 40px;
  bottom: 40px;
  z-index: 2;
  font-size: 11px;
  line-height: 1.7;
  letter-spacing: 0.02em;
  color: var(--ink);
  margin: 0;
}
EOF

echo "Wrote src/app/page.tsx and src/app/page.module.css"

# ---------- 2) Wire /result BACK button to go home ----------
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
    print("Patched", path, "— BACK now routes to /")
else:
    print("Could not find the exact footer markup in", path)
    print("Open src/app/result/page.tsx, find the BACK button/div, and either:")
    print('  - wrap it in a <button onClick={() => router.push("/")}> ...')
    print('  - or tell me and I will send a full-file replacement instead.')
PYEOF

# make footer a flex button that looks like the old div (only matters if patch applied)
if grep -q "footer {" src/app/result/result.module.css 2>/dev/null; then
python3 - << 'PYEOF'
path = "src/app/result/result.module.css"
with open(path) as f:
    css = f.read()

old = '''.footer {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-top: 24px;
}'''

new = '''.footer {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-top: 24px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  font-family: inherit;
}'''

if old in css:
    css = css.replace(old, new)
    with open(path, "w") as f:
        f.write(css)
    print("Patched result.module.css footer styles for button reset")
PYEOF
fi

echo "Done. Refresh localhost:3000/ — that's now the Skinstric homepage."
