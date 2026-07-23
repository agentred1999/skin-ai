"use client";

import { useRef } from "react";
import { useRouter } from "next/navigation";
import styles from "./permissions.module.css";

export default function PermissionsPage() {
  const router = useRouter();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileChosen = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      sessionStorage.setItem("skinstric_uploaded_image", reader.result as string);
      router.push("/scan?source=gallery");
    };
    reader.readAsDataURL(file);
  };

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

      <div className={styles.previewBox}>
        <div className={styles.previewLabel}>Preview</div>
        <div className={styles.previewSquare} />
      </div>

      <div className={styles.stage}>
        <button className={styles.option} onClick={() => router.push("/scan")}>
          <div className={styles.diamondFrame} />
          <div className={styles.iconCircle}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="1.4">
              <path d="M4 8 L7 8 L9 5 L15 5 L17 8 L20 8 A1 1 0 0 1 21 9 L21 18 A1 1 0 0 1 20 19 L4 19 A1 1 0 0 1 3 18 L3 9 A1 1 0 0 1 4 8 Z" />
              <circle cx="12" cy="13.5" r="3.6" />
            </svg>
          </div>
          <div className={styles.optionLabel}>
            ALLOW A.I.<br />TO SCAN YOUR FACE
          </div>
        </button>

        <button className={styles.option} onClick={() => fileInputRef.current?.click()}>
          <div className={styles.diamondFrame} />
          <div className={styles.iconCircle}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="1.4">
              <path d="M4 6 H20 A1 1 0 0 1 21 7 V17 A1 1 0 0 1 20 18 H4 A1 1 0 0 1 3 17 V7 A1 1 0 0 1 4 6 Z" />
              <path d="M4 17 L9 11 L13 15 L16 12 L20 17" />
              <circle cx="8" cy="10" r="1.4" />
            </svg>
          </div>
          <div className={styles.optionLabel}>
            ALLOW A.I.<br />ACCESS GALLERY
          </div>
        </button>
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          style={{ display: "none" }}
          onChange={handleFileChosen}
        />
      </div>

      <div className={styles.footer}>
        <button className={styles.backBtn} onClick={() => router.push("/testing")}>
          <div className={styles.navDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M15 5 L8 12 L15 19" />
            </svg>
          </div>
          <span className={styles.navLabel}>BACK</span>
        </button>
      </div>
    </div>
  );
}
