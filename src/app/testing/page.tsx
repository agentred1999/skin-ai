"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./testing.module.css";

type Stage = "intro" | "city" | "processing" | "done";

export default function TestingPage() {
  const router = useRouter();
  const [stage, setStage] = useState<Stage>("intro");

  const [name, setName] = useState("");
  const [city, setCity] = useState("");

  const goProceed = () => {
    if (stage === "intro") setStage("city");
    else if (stage === "city") {
      setStage("processing");
      setTimeout(() => setStage("done"), 2500);
    } else if (stage === "done") router.push("/permissions");
  };

  const goBack = () => {
    if (stage === "intro") router.push("/result");
    else if (stage === "city") setStage("intro");
    else if (stage === "done") setStage("city");
  };

  const canProceed =
    (stage === "intro" && name.trim().length > 0) ||
    (stage === "city" && city.trim().length > 0);

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

      <div className={styles.stage}>
        <div className={styles.diamondFrame} />

        <div className={styles.content}>
          {stage === "intro" && (
            <>
              <div className={styles.inputLabel}>CLICK TO TYPE</div>
              <input
                className={styles.inputField}
                placeholder="Introduce Yourself"
                value={name}
                onChange={(e) => setName(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter" && canProceed) goProceed();
                }}
                autoFocus
              />
            </>
          )}

          {stage === "city" && (
            <>
              <div className={styles.inputLabel}>CLICK TO TYPE</div>
              <input
                className={styles.inputField}
                placeholder="your city name"
                value={city}
                onChange={(e) => setCity(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter" && canProceed) goProceed();
                }}
                autoFocus
              />
            </>
          )}

          {stage === "processing" && (
            <>
              <div className={styles.processingText}>Processing submission</div>
              <div className={styles.dots}>
                <span></span>
                <span></span>
                <span></span>
              </div>
            </>
          )}

          {stage === "done" && (
            <>
              <div className={styles.thankYou}>Thank you!</div>
              <div className={styles.proceedText}>Proceed for the next step</div>
            </>
          )}
        </div>
      </div>

      <div className={styles.footer}>
        <button className={styles.backBtn} onClick={goBack}>
          <div className={styles.navDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M15 5 L8 12 L15 19" />
            </svg>
          </div>
          <span className={styles.navLabel}>BACK</span>
        </button>

        {(stage === "done" || canProceed) && (
          <button className={styles.proceedBtn} onClick={goProceed}>
            <span className={styles.navLabel}>PROCEED</span>
            <div className={styles.navDiamond}>
              <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
                <path d="M9 5 L16 12 L9 19" />
              </svg>
            </div>
          </button>
        )}
      </div>
    </div>
  );
}
