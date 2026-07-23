#!/bin/bash
set -e

python3 - << 'PYEOF'
path = "src/app/scan/page.tsx"
with open(path) as f:
    tsx = f.read()

# 1) add analyzing state
old_state = '  const [capturedImage, setCapturedImage] = useState<string | null>(null);'
new_state = '''  const [capturedImage, setCapturedImage] = useState<string | null>(null);
  const [analyzing, setAnalyzing] = useState(false);'''
assert old_state in tsx, "capturedImage state not found"
tsx = tsx.replace(old_state, new_state)

# 2) handleConfirm shows the analyzing overlay before navigating
old_confirm = '''  const handleConfirm = () => {
    // TODO: hand capturedImage off to wherever the analysis step lives
    // e.g. sessionStorage.setItem("skinstric_capture", capturedImage!)
    router.push("/result"); // placeholder — tell me the real next route
  };'''
new_confirm = '''  const handleConfirm = () => {
    setAnalyzing(true);
    // TODO: replace this with the real analysis call, e.g.
    //   await fetch("/api/analyze", { method: "POST", body: capturedImage })
    // then router.push to wherever the results actually live.
    setTimeout(() => {
      router.push("/result"); // placeholder — tell me the real next route
    }, 2200);
  };'''
assert old_confirm in tsx, "handleConfirm not found"
tsx = tsx.replace(old_confirm, new_confirm)

# 3) button shows "Uploading..." and disables while analyzing; add the overlay
old_buttons = '''              <div className={styles.reviewButtons}>
                <button className={styles.retakeBtn} onClick={handleRetake}>
                  Retake
                </button>
                <button className={styles.confirmBtn} onClick={handleConfirm}>
                  Use This Photo
                </button>
              </div>
            </div>
          </>
        )}'''
new_buttons = '''              <div className={styles.reviewButtons}>
                <button
                  className={styles.retakeBtn}
                  onClick={handleRetake}
                  disabled={analyzing}
                >
                  Retake
                </button>
                <button
                  className={styles.confirmBtn}
                  onClick={handleConfirm}
                  disabled={analyzing}
                >
                  {analyzing ? "Uploading..." : "Use This Photo"}
                </button>
              </div>
            </div>
            {analyzing && (
              <div className={styles.analyzingBox}>
                <div className={styles.analyzingTitle}>ANALYZING IMAGE...</div>
                <div className={styles.analyzingDots}>
                  <span></span>
                  <span></span>
                  <span></span>
                </div>
              </div>
            )}
          </>
        )}'''
assert old_buttons in tsx, "review buttons block not found"
tsx = tsx.replace(old_buttons, new_buttons)

with open(path, "w") as f:
    f.write(tsx)

print("Patched", path)
PYEOF

cat >> src/app/scan/scan.module.css << 'EOF'

.analyzingBox {
  position: absolute;
  left: 50%;
  top: 55%;
  transform: translate(-50%, -50%);
  z-index: 3;
  background: rgba(232, 232, 230, 0.92);
  border-radius: 6px;
  padding: 24px 32px;
  min-width: 210px;
  text-align: center;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
}

.analyzingTitle {
  color: #1a1a1a;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.01em;
}

.analyzingDots {
  display: flex;
  justify-content: center;
  gap: 6px;
  margin-top: 14px;
}

.analyzingDots span {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #8a8a85;
  animation: pulseDot 1.2s infinite ease-in-out;
}

.analyzingDots span:nth-child(2) {
  animation-delay: 0.2s;
}

.analyzingDots span:nth-child(3) {
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

.retakeBtn:disabled,
.confirmBtn:disabled {
  opacity: 0.7;
  cursor: default;
}
EOF

echo "Done. Refresh localhost:3000/scan, take a picture, click Use This Photo."
