"use client";

import { useRef, useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./result.module.css";

export default function ResultIntro() {
  const router = useRouter();
  const [showCameraPrompt, setShowCameraPrompt] = useState(false);
  const galleryInputRef = useRef<HTMLInputElement>(null);

  const requestCamera = () => {
    // Don't open the camera here — just confirm intent and let /scan
    // request getUserMedia exactly once. Opening it twice back-to-back
    // can leave some webcams stuck showing a black frame.
    setShowCameraPrompt(false);
    router.push("/scan");
  };

  const handleGalleryFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    router.push("/scan"); // TODO: point this at your actual upload/preview route
  };
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
            onClick={() => setShowCameraPrompt(true)}
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
          <svg className={styles.connector} viewBox="0 0 260 260">
            <line x1="167" y1="99" x2="212" y2="62" />
            <circle cx="212" cy="62" r="3" />
          </svg>
          <div className={styles.callout}>
            ALLOW A.I.
            <br />
            TO SCAN YOUR FACE
          </div>
          {showCameraPrompt && (
            <div className={styles.cameraPrompt}>
              <div className={styles.cameraPromptTitle}>
                ALLOW A.I. TO ACCESS YOUR CAMERA
              </div>
              <div className={styles.cameraPromptFooter}>
                <button
                  className={styles.denyBtn}
                  onClick={() => setShowCameraPrompt(false)}
                >
                  DENY
                </button>
                <button className={styles.allowBtn} onClick={requestCamera}>
                  ALLOW
                </button>
              </div>
            </div>
          )}
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
            onClick={() => galleryInputRef.current?.click()}
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
          <svg className={styles.connector} viewBox="0 0 260 260">
            <line x1="93" y1="161" x2="48" y2="198" />
            <circle cx="48" cy="198" r="3" />
          </svg>
          <div className={styles.callout}>
            ALLOW A.I.
            <br />
            ACCESS GALLERY
          </div>
          <input
            ref={galleryInputRef}
            type="file"
            accept="image/*"
            style={{ display: "none" }}
            onChange={handleGalleryFile}
          />
        </div>
      </div>

      <button className={styles.footer} onClick={() => router.push("/")}>
        <div className={styles.backDiamond}>
          <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
            <path d="M15 5 L8 12 L15 19" />
          </svg>
        </div>
        <div className={styles.backLabel}>BACK</div>
      </button>
    </div>
  );
}
