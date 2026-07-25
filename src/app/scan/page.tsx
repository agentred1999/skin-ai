"use client";

import { Suspense, useEffect, useRef, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import styles from "./scan.module.css";

function CameraIcon({ color }: { color: string }) {
  const bg = color === "#0d0d0d" ? "#ffffff" : "#000000";
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.6">
      <circle cx="12" cy="12" r="10" />
      <g fill={color} stroke="none">
        <path d="M12 12 L12 3.2 A8.8 8.8 0 0 1 19.7 7.6 Z" />
        <path d="M12 12 L19.7 7.6 A8.8 8.8 0 0 1 19.7 16.4 Z" />
        <path d="M12 12 L19.7 16.4 A8.8 8.8 0 0 1 12 20.8 Z" />
        <path d="M12 12 L12 20.8 A8.8 8.8 0 0 1 4.3 16.4 Z" />
        <path d="M12 12 L4.3 16.4 A8.8 8.8 0 0 1 4.3 7.6 Z" />
        <path d="M12 12 L4.3 7.6 A8.8 8.8 0 0 1 12 3.2 Z" />
      </g>
      <circle cx="12" cy="12" r="3.4" fill={bg} stroke="none" />
    </svg>
  );
}

function LoadingDiamond({
  label,
  theme = "dark-bg",
  showDots = false,
}: {
  label: string;
  theme?: "dark-bg" | "light-bg";
  showDots?: boolean;
}) {
  const isLight = theme === "light-bg";
  return (
    <div
      className={`${styles.loadingWrap} ${isLight ? styles.loadingWrapLight : ""}`}
    >
      <div className={`${styles.diamondFrame} ${isLight ? styles.diamondFrameLight : ""}`}>
        <span className={styles.d1} />
        <span className={styles.d2} />
        <div
          className={`${styles.loadingIconCircle} ${
            isLight ? styles.loadingIconCircleLight : ""
          }`}
        >
          <CameraIcon color={isLight ? "#0d0d0d" : "#ffffff"} />
        </div>
      </div>
      <div className={`${styles.loadingLabel} ${isLight ? styles.loadingLabelLight : ""}`}>
        {label}
      </div>
      {showDots && (
        <div className={styles.analyzingDots}>
          <span />
          <span />
          <span />
        </div>
      )}
    </div>
  );
}

function minDelay<T>(promise: Promise<T>, ms: number): Promise<T> {
  return Promise.all([promise, new Promise((resolve) => setTimeout(resolve, ms))]).then(
    ([result]) => result
  );
}

function ScanPageInner() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const isGalleryMode = searchParams.get("source") === "gallery";

  const videoRef = useRef<HTMLVideoElement>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [ready, setReady] = useState(false);
  const [capturedImage, setCapturedImage] = useState<string | null>(null);
  const [analyzing, setAnalyzing] = useState(false);

  const analyzeImage = async (imageDataUrl: string) => {
    setAnalyzing(true);

    const base64Only = imageDataUrl.split(",")[1] || imageDataUrl;

    try {
      const res = await minDelay(
        fetch(
          "https://us-central1-frontend-simplified.cloudfunctions.net/skinstricPhaseTwo",
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ image: base64Only }),
          }
        ),
        1600
      );

      const bodyText = await res.text();

      if (!res.ok) {
        throw new Error(`${res.status} ${res.statusText} — ${bodyText.slice(0, 300)}`);
      }

      let json: { data?: Record<string, unknown> };
      try {
        json = JSON.parse(bodyText);
      } catch {
        throw new Error(`Response wasn't valid JSON: ${bodyText.slice(0, 300)}`);
      }

      if (!json?.data) {
        throw new Error(`Response missing "data": ${bodyText.slice(0, 300)}`);
      }

      sessionStorage.setItem("skinstric_demographics", JSON.stringify(json.data));
      router.push("/select");
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      console.error("Phase 2 API error:", message);
      setAnalyzing(false);
      alert(`Analysis failed:\n\n${message}`);
    }
  };

  useEffect(() => {
    if (isGalleryMode) {
      const uploaded = sessionStorage.getItem("skinstric_uploaded_image");
      if (uploaded) {
        queueMicrotask(() => {
          setCapturedImage(uploaded);
          analyzeImage(uploaded);
        });
      } else {
        queueMicrotask(() => setError("No uploaded image found. Please go back and choose a photo."));
      }
      return;
    }

    let cancelled = false;

    (async () => {
      try {
        const stream = await minDelay(
          navigator.mediaDevices.getUserMedia({
            video: { facingMode: "user" },
          }),
          1200
        );
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
        const name = err instanceof DOMException ? err.name : "UnknownError";
        const message = err instanceof Error ? err.message : String(err);
        console.warn("getUserMedia failed:", name, message);
        setError(`Camera error (${name}): ${message}`);
      }
    })();

    return () => {
      cancelled = true;
      streamRef.current?.getTracks().forEach((t) => t.stop());
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isGalleryMode]);

  const handleCapture = () => {
    const video = videoRef.current;
    if (!video) return;

    const canvas = document.createElement("canvas");
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    ctx.translate(canvas.width, 0);
    ctx.scale(-1, 1);
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

    setCapturedImage(canvas.toDataURL("image/jpeg", 0.85));
  };

  const handleRetake = () => {
    if (isGalleryMode) {
      router.push("/permissions");
      return;
    }
    setCapturedImage(null);
    setAnalyzing(false);
  };

  const handleConfirm = () => {
    if (!capturedImage) return;
    analyzeImage(capturedImage);
  };

  const showCameraLoading = !isGalleryMode && !ready && !error && !capturedImage;
  const showCameraLive = !isGalleryMode && ready && !capturedImage;
  const showPreparingScreen = isGalleryMode && analyzing;

  return (
    <div className={styles.page}>
      <div className={styles.topbar}>
        <div className={styles.brand}>
          <span className={styles.brandMark}>SKINSTRIC</span>
          <span className={styles.brandSub}>[ SCAN ]</span>
        </div>
        <button className={styles.enterCode}>ENTER CODE</button>
      </div>

      <div className={`${styles.stage} ${showCameraLoading || showPreparingScreen ? styles.stageLight : ""}`}>
        <video
          ref={videoRef}
          className={styles.video}
          muted
          autoPlay
          playsInline
          style={{ display: showCameraLive ? "block" : "none" }}
        />

        {capturedImage && !showPreparingScreen && (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={capturedImage} alt="Captured photo" className={styles.video} />
        )}

        {error && <div className={styles.error}>{error}</div>}

        {showCameraLoading && (
          <>
            <LoadingDiamond label="SETTING UP CAMERA..." theme="light-bg" />
            <div className={`${styles.guidanceStatic} ${styles.guidanceStaticLight}`}>
              <div className={styles.guidanceTitle}>
                TO GET BETTER RESULTS MAKE SURE TO HAVE
              </div>
              <div className={styles.guidanceItems}>
                <span>&#9671; NEUTRAL EXPRESSION</span>
                <span>&#9671; FRONTAL POSE</span>
                <span>&#9671; ADEQUATE LIGHTING</span>
              </div>
              <div className={styles.loadingBarTrack}>
                <div className={styles.loadingBarFill} />
              </div>
            </div>
          </>
        )}

        {showCameraLive && (
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

            <button className={styles.backBtn} onClick={() => router.push("/permissions")}>
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

        {capturedImage && !isGalleryMode && !analyzing && (
          <>
            <div className={styles.greatShot}>GREAT SHOT!</div>
            <div className={styles.reviewBar}>
              <div className={styles.previewLabel}>Preview</div>
              <div className={styles.reviewButtons}>
                <button className={styles.retakeBtn} onClick={handleRetake}>
                  Retake
                </button>
                <button className={styles.confirmBtn} onClick={handleConfirm}>
                  Use This Photo
                </button>
              </div>
            </div>
          </>
        )}

        {analyzing && (
          <LoadingDiamond
            label="PREPARING YOUR ANALYSIS..."
            theme={showPreparingScreen ? "light-bg" : "dark-bg"}
            showDots
          />
        )}
      </div>
    </div>
  );
}

export default function ScanPage() {
  return (
    <Suspense fallback={null}>
      <ScanPageInner />
    </Suspense>
  );
}
