#!/bin/bash
set -e

# Adjust this if your route lives somewhere else
mkdir -p src/app/result

cat > src/app/result/page.tsx << 'EOF'
"use client";

import styles from "./result.module.css";

export default function ResultIntro() {
  return (
    <div className={styles.page}>
      <div className={styles.topbar}>
        <div className={styles.brand}>
          <span className={styles.brandMark}>SKINSTRIC</span>
          <span className={styles.brandSub}>[ INTRO ]</span>
        </div>
        <div className={styles.topbarRight}>
          <button className={styles.enterCode}>ENTER CODE</button>
          <div className={styles.previewBlock}>
            <div className={styles.previewLabel}>Preview</div>
            <div className={styles.previewBox} />
          </div>
        </div>
      </div>

      <div className={styles.title}>TO START ANALYSIS</div>

      <div className={styles.stage}>
        <div className={`${styles.option} ${styles.optionScan}`}>
          <div className={styles.star}>
            <span className={styles.s1} />
            <span className={styles.s2} />
            <span className={styles.s3} />
          </div>
          <button
            className={styles.iconCircle}
            aria-label="Allow camera to scan your face"
            onClick={() => {
              // TODO: trigger camera permission flow
            }}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="1.6">
              <circle cx="12" cy="12" r="10" />
              <g fill="#0d0d0d" stroke="none">
                <path d="M12 12 L12 3.2 A8.8 8.8 0 0 1 19.7 7.6 Z" />
                <path d="M12 12 L19.7 7.6 A8.8 8.8 0 0 1 19.7 16.4 Z" />
                <path d="M12 12 L19.7 16.4 A8.8 8.8 0 0 1 12 20.8 Z" />
                <path d="M12 12 L12 20.8 A8.8 8.8 0 0 1 4.3 16.4 Z" />
                <path d="M12 12 L4.3 16.4 A8.8 8.8 0 0 1 4.3 7.6 Z" />
                <path d="M12 12 L4.3 7.6 A8.8 8.8 0 0 1 12 3.2 Z" />
              </g>
              <circle cx="12" cy="12" r="3.4" fill="#ffffff" stroke="none" />
            </svg>
          </button>
          <div className={styles.callout}>
            <div className={styles.leadLine} />
            <div className={styles.dot} />
            ALLOW A.I.
            <br />
            TO SCAN YOUR FACE
          </div>
        </div>

        <div className={`${styles.option} ${styles.optionGallery}`}>
          <div className={styles.star}>
            <span className={styles.s1} />
            <span className={styles.s2} />
            <span className={styles.s3} />
          </div>
          <button
            className={styles.iconCircle}
            aria-label="Allow access to your photo gallery"
            onClick={() => {
              // TODO: trigger gallery file picker
            }}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="1.6">
              <rect x="2.2" y="2.2" width="19.6" height="19.6" rx="5" />
              <path
                d="M2.2 16 L8 10 L12.2 14.2 L16 10.4 L21.8 16.2 L21.8 19.4 A2.2 2.2 0 0 1 19.6 21.6 L4.4 21.6 A2.2 2.2 0 0 1 2.2 19.4 Z"
                fill="#0d0d0d"
                stroke="none"
              />
              <circle cx="8" cy="8" r="2" fill="#0d0d0d" stroke="none" />
            </svg>
          </button>
          <div className={styles.callout}>
            <div className={styles.leadLine} />
            <div className={styles.dot} />
            ALLOW A.I.
            <br />
            ACCESS GALLERY
          </div>
        </div>
      </div>

      <div className={styles.footer}>
        <div className={styles.backDiamond}>
          <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
            <path d="M15 5 L8 12 L15 19" />
          </svg>
        </div>
        <div className={styles.backLabel}>BACK</div>
      </div>
    </div>
  );
}
EOF

cat > src/app/result/result.module.css << 'EOF'
.page {
  --ink: #0d0d0d;
  --line: #d9d9d4;
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

.topbarRight {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 10px;
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

.previewBlock {
  text-align: right;
}

.previewLabel {
  font-size: 11px;
  color: var(--muted);
  margin-bottom: 6px;
}

.previewBox {
  width: 110px;
  height: 68px;
  border: 1px solid var(--line);
}

.title {
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.03em;
  margin: 48px 0 0 0;
}

.stage {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 22vw;
  position: relative;
}

.option {
  position: relative;
  width: 260px;
  height: 260px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.star {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.star span {
  position: absolute;
  width: 200px;
  height: 200px;
  border: 1px dotted var(--line);
  animation: spin 40s linear infinite;
}

.s2 {
  animation-duration: 55s;
  animation-direction: reverse;
}

.s3 {
  width: 170px;
  height: 170px;
  animation-duration: 70s;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.iconCircle {
  position: relative;
  z-index: 2;
  width: 96px;
  height: 96px;
  border-radius: 50%;
  border: 1.5px solid var(--ink);
  background: var(--paper);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  padding: 0;
}

.iconCircle svg {
  width: 56px;
  height: 56px;
}

.callout {
  position: absolute;
  z-index: 2;
  font-size: 11px;
  line-height: 1.5;
  letter-spacing: 0.02em;
  white-space: nowrap;
}

.leadLine {
  position: absolute;
  background: var(--ink);
  height: 1px;
  transform-origin: left center;
}

.dot {
  position: absolute;
  width: 5px;
  height: 5px;
  border-radius: 50%;
  border: 1px solid var(--ink);
  background: var(--paper);
}

.optionScan .callout {
  left: 118px;
  bottom: 128px;
}

.optionScan .leadLine {
  left: -66px;
  bottom: 8px;
  width: 66px;
  transform: rotate(-32deg);
}

.optionScan .dot {
  left: -70px;
  bottom: 4px;
}

.optionGallery .callout {
  right: 118px;
  top: 128px;
  text-align: right;
}

.optionGallery .leadLine {
  right: -66px;
  top: 8px;
  width: 66px;
  transform: rotate(-32deg);
}

.optionGallery .dot {
  right: -70px;
  top: 4px;
}

.footer {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-top: 24px;
}

.backDiamond {
  width: 34px;
  height: 34px;
  border: 1px solid var(--ink);
  transform: rotate(45deg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.backDiamond svg {
  transform: rotate(-45deg);
  width: 14px;
  height: 14px;
}

.backLabel {
  font-size: 12px;
  letter-spacing: 0.04em;
}
EOF

echo "Wrote src/app/result/page.tsx and src/app/result/result.module.css"
