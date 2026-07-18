"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useRef, useState } from "react";
import styles from "./page.module.css";


function ChevronIcon({ direction }: { direction: "left" | "right" }) {
  return (
    <svg width="14" height="14" viewBox="0 0 12 12">
      <polygon
        points={direction === "left" ? "9,1 3,6 9,11" : "3,1 9,6 3,11"}
        fill="currentColor"
      />
    </svg>
  );
}
function HoldToNavigate({
  href,
  side,
  icon,
  label,
}: {
  href: string;
  side: "left" | "right";
  icon: React.ReactNode;
  label: string;
}) {
  const router = useRouter();
  const [holding, setHolding] = useState(false);
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const start = () => {
    setHolding(true);
    timerRef.current = setTimeout(() => {
      router.push(href);
    }, 800);
  };

  const cancel = () => {
    setHolding(false);
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }
  };

  return (
    <div
      className={`${styles.sideAction} ${styles[side]}`}
      onMouseDown={start}
      onMouseUp={cancel}
      onMouseLeave={cancel}
      onTouchStart={start}
      onTouchEnd={cancel}
      role="button"
      tabIndex={0}
    >
      <div className={styles.diamond}>
        <span className={`${styles.diamondFill} ${holding ? styles.diamondFilling : ""}`} />
        <span className={styles.diamondIcon}>{icon}</span>
      </div>
      <span className={styles.sideActionLabel}>{label}</span>
    </div>
  );
}

export default function Home() {
  return (
    <div className={styles.page}>
      <svg style={{ position: "fixed", top: 0, left: 0, pointerEvents: "none", zIndex: 0 }} width="240" height="240" viewBox="0 0 240 240">
        <polyline points="240,40 170,170 40,240" fill="none" stroke="rgba(0,0,0,0.25)" strokeWidth="1.5" strokeDasharray="5 6" />
      </svg>
      <svg style={{ position: "fixed", top: 0, right: 0, pointerEvents: "none", zIndex: 0 }} width="240" height="240" viewBox="0 0 240 240">
        <polyline points="0,40 70,170 200,240" fill="none" stroke="rgba(0,0,0,0.25)" strokeWidth="1.5" strokeDasharray="5 6" />
      </svg>
      <svg style={{ position: "fixed", bottom: 0, left: 0, pointerEvents: "none", zIndex: 0 }} width="240" height="240" viewBox="0 0 240 240">
        <polyline points="240,200 170,70 40,0" fill="none" stroke="rgba(0,0,0,0.25)" strokeWidth="1.5" strokeDasharray="5 6" />
      </svg>
      <svg style={{ position: "fixed", bottom: 0, right: 0, pointerEvents: "none", zIndex: 0 }} width="240" height="240" viewBox="0 0 240 240">
        <polyline points="0,200 70,70 200,0" fill="none" stroke="rgba(0,0,0,0.25)" strokeWidth="1.5" strokeDasharray="5 6" />
      </svg>

      <header className={styles.header}>
        <div className={styles.logoGroup}>
          <span className={styles.logo}>SKINSTRIC</span>
          <span className={styles.introTag}>[ INTRO ]</span>
        </div>
        <button className={styles.enterCodeButton}>Enter Code</button>
      </header>

      <main className={styles.main}>
        <div className={styles.mobileDiamond} />
        <div className={styles.mobileDiamondInner} />

        <h1 className={styles.headline}>
          Sophisticated
          <br />
          skincare
        </h1>

        <p className={styles.mobileSubtext}>
          Skinstric developed an A.I. that creates a highly-personalized
          routine tailored to what your skin needs.
        </p>

        <Link href="/testing" className={styles.enterExperience}>
          Enter Experience
          <span className={styles.enterExperienceIcon}>
            <span className={styles.enterExperienceArrow}>&#9654;</span>
          </span>
        </Link>

        <HoldToNavigate href="/testing" side="left" icon={<ChevronIcon direction="left" />} label="Discover A.I." />

        <HoldToNavigate href="/testing" side="right" icon={<ChevronIcon direction="right" />} label="Take Test" />
      </main>

      <footer className={styles.footer}>
        <p className={styles.subtext}>
          Skinstric developed an A.I. that creates a highly-personalized
          routine tailored to what your skin needs.
        </p>
      </footer>
    </div>
  );
}
