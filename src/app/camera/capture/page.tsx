'use client';

import { useEffect, useRef, useState } from 'react';
import { useRouter } from 'next/navigation';
import styles from './capture.module.css';

function DiamondArrow({ direction }: { direction: 'left' | 'right' }) {
  return (
    <span className={styles.diamondWrap}>
      <span className={styles.diamondBox} />
      <span
        className={`${styles.diamondArrowChar} ${
          direction === 'left' ? styles.arrowLeft : styles.arrowRight
        }`}
      >
        ▶
      </span>
    </span>
  );
}

export default function CameraCapturePage() {
  const router = useRouter();
  const videoRef = useRef<HTMLVideoElement>(null);
  const [error, setError] = useState('');

  useEffect(() => {
    let stream: MediaStream | null = null;

    const startCamera = async () => {
      try {
        stream = await navigator.mediaDevices.getUserMedia({ video: true });
        if (videoRef.current) {
          videoRef.current.srcObject = stream;
        }
      } catch (err) {
        setError('Camera access denied or unavailable.');
      }
    };

    startCamera();

    return () => {
      stream?.getTracks().forEach((track) => track.stop());
    };
  }, []);

  const handleTakePicture = () => {
    console.log('take picture clicked');
  };

  return (
    <main className={styles.page}>
      <header className={styles.nav}>
        <div className={styles.navLeft}>
          <span className={styles.logo}>SKINSTRIC</span>
          <span className={styles.crumb}>
            [ <span className={styles.crumbLabel}>INTRO</span> ]
          </span>
        </div>
        <button className={styles.enterCode}>ENTER CODE</button>
      </header>

      <div className={styles.videoWrap}>
        {error ? (
          <p className={styles.errorText}>{error}</p>
        ) : (
          <video ref={videoRef} autoPlay muted playsInline className={styles.video} />
        )}

        <div className={styles.tipsBlock}>
          <p className={styles.tipsTitle}>TO GET BETTER RESULTS MAKE SURE TO HAVE</p>
          <div className={styles.tipsRow}>
            <span className={styles.tip}>◇ NEUTRAL EXPRESSION</span>
            <span className={styles.tip}>◇ FRONTAL POSE</span>
            <span className={styles.tip}>◇ ADEQUATE LIGHTING</span>
          </div>
        </div>

        <button type="button" className={styles.takePicture} onClick={handleTakePicture}>
          <span className={styles.takePictureLabel}>TAKE PICTURE</span>
          <span className={styles.takePictureButton}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="10" stroke="#0a0a0a" strokeWidth="1.2" />
              <circle cx="12" cy="12" r="3.5" stroke="#0a0a0a" strokeWidth="1.2" />
            </svg>
          </span>
        </button>
      </div>

      <button className={styles.back} onClick={() => router.push('/result')}>
        <DiamondArrow direction="left" />
        BACK
      </button>
    </main>
  );
}
