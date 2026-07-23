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

  return (
    <div
      className={`${styles.sideAction} ${styles[side]}`}
      onClick={() => router.push(href)}
      role="button"
      tabIndex={0}
      style={{ cursor: "pointer" }}
    >
      <div className={styles.diamond}>
        <span className={styles.diamondIcon}>{icon}</span>
      </div>
      <span className={styles.sideActionLabel}>{label}</span>
    </div>
  );
}

export default function Home() {
  return (
    <div className={styles.page}>
      <svg style={{ position: "fixed", top: "50%", left: "-120px", transform: "translateY(-50%)", pointerEvents: "none", zIndex: 0 }} width="420" height="900" viewBox="0 0 420 900">
        <polyline points="0,0 380,450 0,900" fill="none" stroke="rgba(0,0,0,0.12)" strokeWidth="1" />
      </svg>
      <svg style={{ position: "fixed", top: "50%", right: "-120px", transform: "translateY(-50%)", pointerEvents: "none", zIndex: 0 }} width="420" height="900" viewBox="0 0 420 900">
        <polyline points="380,0 0,450 380,900" fill="none" stroke="rgba(0,0,0,0.12)" strokeWidth="1" />
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
