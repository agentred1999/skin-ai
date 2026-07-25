"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./summary.module.css";

type ScoreMap = Record<string, number>;

interface Demographics {
  race: ScoreMap;
  age: ScoreMap;
  gender: ScoreMap;
}

function sortedEntries(map: ScoreMap | undefined) {
  if (!map) return [];
  return Object.entries(map).sort((a, b) => b[1] - a[1]);
}

function toPercent(n: number) {
  return (n * 100).toFixed(2);
}

function toLabel(key: string) {
  return key
    .split(" ")
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(" ");
}

export default function SummaryPage() {
  const router = useRouter();
  const [data, setData] = useState<Demographics | null>(null);
  const [actualRace, setActualRace] = useState<string>("");
  const [actualAge, setActualAge] = useState<string>("");
  const [actualSex, setActualSex] = useState<string>("");

  useEffect(() => {
    const raw = sessionStorage.getItem("skinstric_demographics");
    if (!raw) {
      router.push("/scan");
      return;
    }
    const parsed: Demographics = JSON.parse(raw);
    setData(parsed);

    const raceSorted = sortedEntries(parsed.race);
    const ageSorted = sortedEntries(parsed.age);
    const genderSorted = sortedEntries(parsed.gender);

    if (raceSorted[0]) setActualRace(raceSorted[0][0]);
    if (ageSorted[0]) setActualAge(ageSorted[0][0]);
    if (genderSorted[0]) setActualSex(genderSorted[0][0]);
  }, [router]);

  if (!data) return null;

  const raceSorted = sortedEntries(data.race);
  const topRacePct = raceSorted.length ? toPercent(raceSorted[0][1]) : "0.00";
  const circumference = 2 * Math.PI * 170;
  const dashOffset = circumference * (1 - parseFloat(topRacePct) / 100);

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
        <div className={styles.eyebrow}>A.I. ANALYSIS</div>
        <div className={styles.bigTitle}>DEMOGRAPHICS</div>
        <div className={styles.eyebrowSub}>PREDICTED RACE &amp; AGE</div>
      </div>

      <div className={styles.mainGrid}>
        <div className={styles.leftRail}>
          <div className={styles.railItem}>
            <div className={styles.railValue}>{toLabel(actualRace)}</div>
            <div className={styles.railLabel}>RACE</div>
          </div>
          <div className={styles.railItem}>
            <div className={styles.railValue}>{actualAge}</div>
            <div className={styles.railLabel}>AGE</div>
          </div>
          <div className={styles.railItem}>
            <div className={styles.railValue}>{actualSex.toUpperCase()}</div>
            <div className={styles.railLabel}>SEX</div>
          </div>
        </div>

        <div className={styles.centerPanel}>
          <div className={styles.centerLabel}>{toLabel(actualRace)}</div>
          <div className={styles.ringWrap}>
            <svg width="360" height="360" viewBox="0 0 360 360">
              <circle
                cx="180"
                cy="180"
                r="170"
                fill="none"
                stroke="#d9d9d4"
                strokeWidth="2"
              />
              <circle
                cx="180"
                cy="180"
                r="170"
                fill="none"
                stroke="#0d0d0d"
                strokeWidth="2"
                strokeDasharray={circumference}
                strokeDashoffset={dashOffset}
                transform="rotate(-90 180 180)"
              />
            </svg>
            <div className={styles.ringText}>{topRacePct}%</div>
          </div>
        </div>

        <div className={styles.rightList}>
          <div className={styles.rightHeader}>
            <span>RACE</span>
            <span>A.I. CONFIDENCE</span>
          </div>
          {raceSorted.map(([key, val]) => (
            <button
              key={key}
              className={`${styles.rightRow} ${key === actualRace ? styles.rightRowActive : ""}`}
              onClick={() => setActualRace(key)}
            >
              <span className={styles.rowLabel}>
                <span className={styles.rowIcon}>◇</span>
                {toLabel(key)}
              </span>
              <span>{toPercent(val)}%</span>
            </button>
          ))}
        </div>
      </div>

      <div className={styles.footer}>
        <button className={styles.backBtn} onClick={() => router.push("/select")}>
          <div className={styles.navDiamond}>
            <svg viewBox="0 0 24 24" fill="none" stroke="#0d0d0d" strokeWidth="2">
              <path d="M15 5 L8 12 L15 19" />
            </svg>
          </div>
          <span className={styles.navLabel}>BACK</span>
        </button>

        <div className={styles.hint}>If A.I. estimate is wrong, select the correct one.</div>

        <button className={styles.proceedBtn} onClick={() => router.push("/")}>
          <span className={styles.navLabel}>HOME</span>
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
