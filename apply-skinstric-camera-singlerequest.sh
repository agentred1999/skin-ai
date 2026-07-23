#!/bin/bash
set -e

python3 - << 'PYEOF'
path = "src/app/result/page.tsx"
with open(path) as f:
    tsx = f.read()

old = '''  const requestCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ video: true });
      stream.getTracks().forEach((track) => track.stop());
      setShowCameraPrompt(false);
      router.push("/scan"); // TODO: point this at your actual capture route
    } catch (err) {
      setShowCameraPrompt(false);
      alert("Camera access was denied.");
    }
  };'''

new = '''  const requestCamera = () => {
    // Don't open the camera here — just confirm intent and let /scan
    // request getUserMedia exactly once. Opening it twice back-to-back
    // can leave some webcams stuck showing a black frame.
    setShowCameraPrompt(false);
    router.push("/scan");
  };'''

assert old in tsx, "requestCamera block not found — check page.tsx manually"
tsx = tsx.replace(old, new)

with open(path, "w") as f:
    f.write(tsx)

print("Patched", path)
PYEOF

# Make the /scan page's camera request a bit more defensive
python3 - << 'PYEOF'
path = "src/app/scan/page.tsx"
with open(path) as f:
    tsx = f.read()

old = '''        <video
          ref={videoRef}
          className={styles.video}
          muted
          playsInline
          style={{ display: ready ? "block" : "none" }}
        />'''

new = '''        <video
          ref={videoRef}
          className={styles.video}
          muted
          autoPlay
          playsInline
          style={{ display: ready ? "block" : "none" }}
        />'''

assert old in tsx, "video tag not found — check page.tsx manually"
tsx = tsx.replace(old, new)

with open(path, "w") as f:
    f.write(tsx)

print("Patched", path)
PYEOF

echo "Done. Fully reload localhost:3000/result (not just soft navigation) before testing."
