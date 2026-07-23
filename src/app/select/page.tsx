"use client";

import { useRouter } from "next/navigation";
import styles from "./select.module.css";

export default function SelectPage() {
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

      <div className={styles.headerBlock}>
        <div className={styles.title}>A.I. ANALYSIS</div>
        <div className={styles.subtitle}>A.I. HAS ESTIMATED THE FOLLOWING.</div>
        <div className={styles.subtitle}>FIX ESTIMATED INFORMATION IF NEEDED.</div>
      </div>

      <div className={styles.stage}>
        <div className={styles.diamondGrid}>
          <button className={`${styles.cell} ${styles.top}`}>DEMOGRAPHICS</button>
          <button className={`${styles.cell} ${styles.left}`}>
            COSMETIC<br />CONCERNS
          </button>
          <button className={`${styles.cell} ${styles.right}`}>
            SKIN TYPE DETAILS
          </button>
          <button className={`${styles.cell} ${styles.bottom}`}>WEATHER</button>
        </div>
      </div>

      <div className={styles.footer}>
        <button className={styles.backBtn} onClick={() => router.push("/scan")}>
          <div className={styles.navDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M15 5 L8 12 L15 19" />
            </svg>
          </div>
          <span className={styles.navLabel}>BACK</span>
        </button>

        <button className={styles.proceedBtn} onClick={() => router.push("/summary")}>
          <span className={styles.navLabel}>GET SUMMARY</span>
          <div className={styles.navDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M9 5 L16 12 L9 19" />
            </svg>
          </div>
        </button>
      </div>
    </div>
  );
}
