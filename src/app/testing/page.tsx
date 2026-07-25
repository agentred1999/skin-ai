"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./testing.module.css";

type Stage = "intro" | "city" | "processing" | "done";

const NAME_REGEX = /^[A-Za-z\s'-]+$/;

export default function TestingPage() {
  const router = useRouter();
  const [stage, setStage] = useState<Stage>("intro");
  const [name, setName] = useState("");
  const [city, setCity] = useState("");
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const isValidName = NAME_REGEX.test(name.trim());
  const isValidCity = NAME_REGEX.test(city.trim());

  const submitToApi = async () => {
    setSubmitting(true);
    setError("");
    try {
      const res = await fetch(
        "https://us-central1-frontend-simplified.cloudfunctions.net/skinstricPhaseOne",
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ name: name.trim(), location: city.trim() }),
        }
      );
      if (!res.ok) throw new Error("Request failed");
      const data = await res.json();
      console.log("Phase 1 API response:", data);

      localStorage.setItem("skinstric_name", name.trim());
      localStorage.setItem("skinstric_location", city.trim());

      setStage("done");
    } catch (err) {
      setError("Something went wrong submitting your info. Please try again.");
      setStage("city");
    } finally {
      setSubmitting(false);
    }
  };

  const goProceed = () => {
    if (stage === "intro") {
      if (!isValidName) {
        setError("Please enter a valid name (letters only).");
        return;
      }
      setError("");
      setStage("city");
    } else if (stage === "city") {
      if (!isValidCity) {
        setError("Please enter a valid location (letters only).");
        return;
      }
      setError("");
      setStage("processing");
      submitToApi();
    } else if (stage === "done") {
      router.push("/permissions");
    }
  };

  const goBack = () => {
    setError("");
    if (stage === "intro") router.push("/");
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
                onChange={(e) => {
                  setName(e.target.value);
                  setError("");
                }}
                onKeyDown={(e) => {
                  if (e.key === "Enter" && canProceed) goProceed();
                }}
                autoFocus
              />
              {error && <div className={styles.errorText}>{error}</div>}
            </>
          )}

          {stage === "city" && (
            <>
              <div className={styles.inputLabel}>CLICK TO TYPE</div>
              <input
                className={styles.inputField}
                placeholder="your city name"
                value={city}
                onChange={(e) => {
                  setCity(e.target.value);
                  setError("");
                }}
                onKeyDown={(e) => {
                  if (e.key === "Enter" && canProceed) goProceed();
                }}
                autoFocus
              />
              {error && <div className={styles.errorText}>{error}</div>}
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

        {(stage === "done" || canProceed) && !submitting && (
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
