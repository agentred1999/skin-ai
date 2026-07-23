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
  const [capturedImage, setCapturedImage] = useState<string | null>(null);

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

    // mirror the capture to match what's shown on screen
    ctx.translate(canvas.width, 0);
    ctx.scale(-1, 1);
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

    setCapturedImage(canvas.toDataURL("image/png"));
  };

  const handleRetake = () => {
    setCapturedImage(null);
  };

  const handleConfirm = () => {
    // TODO: hand capturedImage off to wherever the analysis step lives
    // e.g. sessionStorage.setItem("skinstric_capture", capturedImage!)
    router.push("/result"); // placeholder — tell me the real next route
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
          autoPlay
          playsInline
          style={{ display: ready && !capturedImage ? "block" : "none" }}
        />

        {capturedImage && (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={capturedImage} alt="Captured photo" className={styles.video} />
        )}

        {!ready && !error && (
          <div className={styles.loading}>REQUESTING CAMERA…</div>
        )}
        {error && <div className={styles.error}>{error}</div>}

        {ready && !capturedImage && (
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

        {capturedImage && (
          <div className={styles.reviewBar}>
            <button className={styles.retakeBtn} onClick={handleRetake}>
              RETAKE
            </button>
            <button className={styles.confirmBtn} onClick={handleConfirm}>
              USE PHOTO
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
EOF

cat >> src/app/scan/scan.module.css << 'EOF'

.reviewBar {
  position: absolute;
  left: 50%;
  bottom: 48px;
  transform: translateX(-50%);
  display: flex;
  gap: 16px;
  z-index: 2;
}

.retakeBtn,
.confirmBtn {
  font-family: inherit;
  font-size: 11px;
  letter-spacing: 0.05em;
  padding: 12px 24px;
  cursor: pointer;
  border: 1px solid #ffffff;
}

.retakeBtn {
  background: transparent;
  color: #ffffff;
}

.confirmBtn {
  background: #ffffff;
  color: #0d0d0d;
  font-weight: 700;
}
EOF

echo "Done. Refresh localhost:3000/scan"
