#!/bin/bash
set -e

mkdir -p src/app/testing

cat > src/app/testing/page.tsx << 'EOF'
"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./testing.module.css";

type Stage = "processing" | "done";

export default function TestingPage() {
  const router = useRouter();
  const [stage, setStage] = useState<Stage>("processing");

  useEffect(() => {
    const timer = setTimeout(() => setStage("done"), 2500);
    return () => clearTimeout(timer);
  }, []);

  return (
    <div className={styles.page}>
      <div className={styles.topbar}>
        <div className={styles.brand}>
          <span className={styles.brandMark}>SKINSTRIC</span>
          <span className={styles.brandSub}>[ INTRO ]</span>
        </div>
        <button className={styles.enterCode}>ENTER CODE</button>
      </div>

      <div className={styles.title}>TO START ANALYSIS</div>

      <div className={styles.stage}>
        <div className={styles.star}>
          <span className={styles.s1} />
          <span className={styles.s2} />
          <span className={styles.s3} />
        </div>

        <div className={styles.content}>
          {stage === "processing" ? (
            <>
              <div className={styles.processingText}>Processing submission</div>
              <div className={styles.dots}>
                <span></span>
                <span></span>
                <span></span>
              </div>
            </>
          ) : (
            <>
              <div className={styles.thankYou}>Thank you!</div>
              <div className={styles.proceedText}>Proceed for the next step</div>
            </>
          )}
        </div>
      </div>

      <div className={styles.footer}>
        <button className={styles.backBtn} onClick={() => router.push("/result")}>
          <div className={styles.navDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M15 5 L8 12 L15 19" />
            </svg>
          </div>
          <span className={styles.navLabel}>BACK</span>
        </button>

        {stage === "done" && (
          <button
            className={styles.proceedBtn}
            onClick={() => router.push("/testing/city")}
          >
            <span className={styles.navLabel}>PROCEED</span>
            <div className={styles.navDiamond}>
              <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
                <path d="M9 5 L16 12 L9 19" />
              </svg>
            </div>
          </button>
        )}
      </div>
    </div>
  );
}
EOF

cat > src/app/testing/testing.module.css << 'EOF'
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

.title {
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.03em;
  margin: 20px 0 0 0;
}

.stage {
  flex: 1;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.star {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: center;
}

.star span {
  position: absolute;
  width: 340px;
  height: 340px;
  border: 1px dotted var(--line);
  animation: spin 45s linear infinite;
}

.s2 {
  animation-duration: 60s;
  animation-direction: reverse;
}

.s3 {
  width: 300px;
  height: 300px;
  animation-duration: 75s;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.content {
  position: relative;
  z-index: 2;
  text-align: center;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
}

.processingText {
  color: var(--muted);
  font-size: 15px;
}

.dots {
  display: flex;
  justify-content: center;
  gap: 6px;
  margin-top: 16px;
}

.dots span {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--muted);
  animation: pulseDot 1.2s infinite ease-in-out;
}

.dots span:nth-child(2) {
  animation-delay: 0.2s;
}

.dots span:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes pulseDot {
  0%, 80%, 100% {
    opacity: 0.3;
    transform: scale(0.85);
  }
  40% {
    opacity: 1;
    transform: scale(1.1);
  }
}

.thankYou {
  color: var(--ink);
  font-size: 26px;
  font-weight: 600;
}

.proceedText {
  color: var(--muted);
  font-size: 15px;
  margin-top: 10px;
}

.footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 24px;
}

.backBtn,
.proceedBtn {
  display: flex;
  align-items: center;
  gap: 14px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  font-family: inherit;
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
EOF

echo "Wrote src/app/testing/page.tsx and src/app/testing/testing.module.css"
