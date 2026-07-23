#!/bin/bash
set -e

mkdir -p src/app/scan

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
      </div>

      <div className={styles.stage}>
        {error && <div className={styles.error}>{error}</div>}
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
      </div>

      <div className={styles.footer}>
        <button className={styles.backBtn} onClick={() => router.push("/result")}>
          <div className={styles.backDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M15 5 L8 12 L15 19" />
            </svg>
          </div>
          <span className={styles.backLabel}>BACK</span>
        </button>

        {ready && (
          <button className={styles.captureBtn} onClick={handleCapture}>
            CAPTURE
          </button>
        )}
      </div>
    </div>
  );
}
EOF

cat > src/app/scan/scan.module.css << 'EOF'
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

.stage {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.video {
  width: 480px;
  max-width: 90vw;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  background: #000;
  border: 1px solid var(--ink);
  transform: scaleX(-1); /* mirror, like a selfie camera */
}

.loading,
.error {
  font-size: 12px;
  letter-spacing: 0.05em;
  color: var(--muted);
}

.error {
  color: #b00020;
}

.footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 24px;
}

.backBtn {
  display: flex;
  align-items: center;
  gap: 14px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  font-family: inherit;
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

.captureBtn {
  background: var(--ink);
  color: var(--paper);
  font-family: inherit;
  font-size: 11px;
  letter-spacing: 0.05em;
  border: none;
  padding: 12px 22px;
  cursor: pointer;
}
EOF

echo "Wrote src/app/scan/page.tsx and src/app/scan/scan.module.css"
