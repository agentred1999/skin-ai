"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useRef, useState } from "react";
import styles from "./page.module.css";


function HoldToNavigate({
  href,
  side,
  icon,
  label,
}: {
  href: string;
  side: "left" | "right";
  icon: string;
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
      <div className="corner-diamond top-left" />
      <div className="corner-diamond top-right" />
      <div className="corner-diamond bottom-left" />
      <div className="corner-diamond bottom-right" />

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
            <span>&#9654;</span>
          </span>
        </Link>

        <HoldToNavigate href="/testing" side="left" icon="◀" label="Discover A.I." />

        <HoldToNavigate href="/testing" side="right" icon="▶" label="Take Test" />
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
