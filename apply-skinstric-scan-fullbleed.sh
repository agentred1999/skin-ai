#!/bin/bash
set -e

cat > src/app/scan/page.tsx << 'EOF'
"use client";

import { useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./scan.module.css";

export default function ScanPage() {
  const router = useRouter();
  const videoRef = useRef<HTMLVideoElement>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [ready, setReady] = useState(false);

  useEffect(() => {
    let cancelled = false;

    (async () => {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({
          video: { facingMode: "user" },
        });
        if (cancelled) {
          stream.getTracks().forEach((t) => t.stop());
          return;
        }
        streamRef.current = stream;
        if (videoRef.current) {
          videoRef.current.srcObject = stream;
          await videoRef.current.play();
        }
        setReady(true);
      } catch (err) {
        setError("Camera access was denied or is unavailable.");
      }
    })();

    return () => {
      cancelled = true;
      streamRef.current?.getTracks().forEach((t) => t.stop());
    };
  }, []);

  const handleCapture = () => {
    const video = videoRef.current;
    if (!video) return;

    const canvas = document.createElement("canvas");
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

    const dataUrl = canvas.toDataURL("image/png");
    // TODO: hand dataUrl off to whatever consumes the captured photo
    console.log("Captured frame", dataUrl.slice(0, 50) + "...");
  };

  return (
    <div className={styles.page}>
      <div className={styles.topbar}>
        <div className={styles.brand}>
          <span className={styles.brandMark}>SKINSTRIC</span>
          <span className={styles.brandSub}>[ SCAN ]</span>
        </div>
        <button className={styles.enterCode}>ENTER CODE</button>
      </div>

      <div className={styles.stage}>
        <video
          ref={videoRef}
          className={styles.video}
          muted
          playsInline
          style={{ display: ready ? "block" : "none" }}
        />

        {!ready && !error && (
          <div className={styles.loading}>REQUESTING CAMERA…</div>
        )}
        {error && <div className={styles.error}>{error}</div>}

        {ready && (
          <>
            <div className={styles.guidance}>
              <div className={styles.guidanceTitle}>
                TO GET BETTER RESULTS MAKE SURE TO HAVE
              </div>
              <div className={styles.guidanceItems}>
                <span>&#9671; NEUTRAL EXPRESSION</span>
                <span>&#9671; FRONTAL POSE</span>
                <span>&#9671; ADEQUATE LIGHTING</span>
              </div>
            </div>

            <button className={styles.backBtn} onClick={() => router.push("/result")}>
              <div className={styles.backDiamond}>
                <svg viewBox="0 0 24 24" fill="none" stroke="#ffffff" strokeWidth="2">
                  <path d="M15 5 L8 12 L15 19" />
                </svg>
              </div>
              <span className={styles.backLabel}>BACK</span>
            </button>

            <button className={styles.captureBtn} onClick={handleCapture}>
              <span className={styles.captureLabel}>TAKE PICTURE</span>
              <span className={styles.captureCircle}>
                <svg viewBox="0 0 24 24" fill="none" stroke="#ffffff" strokeWidth="1.6">
                  <path d="M4 8 L7 8 L9 5 L15 5 L17 8 L20 8 A1 1 0 0 1 21 9 L21 18 A1 1 0 0 1 20 19 L4 19 A1 1 0 0 1 3 18 L3 9 A1 1 0 0 1 4 8 Z" />
                  <circle cx="12" cy="13.5" r="3.6" />
                </svg>
              </span>
            </button>
          </>
        )}
      </div>
    </div>
  );
}
EOF

cat > src/app/scan/scan.module.css << 'EOF'
.page {
  --ink: #0d0d0d;
  --paper: #ffffff;
  --muted: #8a8a85;

  height: 100vh;
  background: #000;
  color: var(--ink);
  font-family: "Courier New", Courier, monospace;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.topbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: var(--paper);
  padding: 24px 40px;
  z-index: 3;
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
  position: relative;
  flex: 1;
  overflow: hidden;
  background: #000;
}

.video {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transform: scaleX(-1); /* mirror, like a selfie camera */
}

.loading,
.error {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 12px;
  letter-spacing: 0.05em;
  color: #ffffff;
}

.error {
  color: #ff6b6b;
}

.guidance {
  position: absolute;
  left: 50%;
  bottom: 64px;
  transform: translateX(-50%);
  text-align: center;
  color: #ffffff;
  z-index: 2;
  text-shadow: 0 1px 4px rgba(0, 0, 0, 0.6);
}

.guidanceTitle {
  font-size: 13px;
  letter-spacing: 0.04em;
  font-weight: 700;
  margin-bottom: 12px;
}

.guidanceItems {
  display: flex;
  gap: 28px;
  font-size: 11px;
  letter-spacing: 0.03em;
}

.backBtn {
  position: absolute;
  left: 40px;
  bottom: 40px;
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

.backDiamond {
  width: 34px;
  height: 34px;
  border: 1px solid #ffffff;
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
  color: #ffffff;
  text-shadow: 0 1px 4px rgba(0, 0, 0, 0.6);
}

.captureBtn {
  position: absolute;
  right: 40px;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  gap: 16px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  font-family: inherit;
  z-index: 2;
}

.captureLabel {
  color: #ffffff;
  font-size: 11px;
  letter-spacing: 0.05em;
  text-shadow: 0 1px 4px rgba(0, 0, 0, 0.6);
}

.captureCircle {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  border: 1.5px solid #ffffff;
  background: rgba(255, 255, 255, 0.08);
  display: flex;
  align-items: center;
  justify-content: center;
}

.captureCircle svg {
  width: 26px;
  height: 26px;
}
EOF

echo "Wrote full-bleed src/app/scan/page.tsx and scan.module.css"
