import Link from "next/link";
import styles from "./page.module.css";

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

        <Link href="/testing" className={`${styles.sideAction} ${styles.left}`}>
          <div className={styles.diamond}>
            <span>&#9664;</span>
          </div>
          <span className={styles.sideActionLabel}>Discover A.I.</span>
        </Link>

        <Link href="/testing" className={`${styles.sideAction} ${styles.right}`}>
          <div className={styles.diamond}>
            <span>&#9654;</span>
          </div>
          <span className={styles.sideActionLabel}>Take Test</span>
        </Link>
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
