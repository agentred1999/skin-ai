#!/bin/bash
set -e

python3 - << 'PYEOF'
path = "src/app/result/page.tsx"
with open(path) as f:
    tsx = f.read()

# 1) imports: add useState/useRef, and useRouter
old_import = '''"use client";

import styles from "./result.module.css";'''

new_import = '''"use client";

import { useRef, useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./result.module.css";'''

assert old_import in tsx, "import block not found — check page.tsx manually"
tsx = tsx.replace(old_import, new_import)

# 2) component state, right after the function opens
old_open = "export default function ResultIntro() {"
new_open = '''export default function ResultIntro() {
  const router = useRouter();
  const [showCameraPrompt, setShowCameraPrompt] = useState(false);
  const galleryInputRef = useRef<HTMLInputElement>(null);

  const requestCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ video: true });
      stream.getTracks().forEach((track) => track.stop());
      setShowCameraPrompt(false);
      router.push("/scan"); // TODO: point this at your actual capture route
    } catch (err) {
      setShowCameraPrompt(false);
      alert("Camera access was denied.");
    }
  };

  const handleGalleryFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    router.push("/scan"); // TODO: point this at your actual upload/preview route
  };'''

assert old_open in tsx, "function signature not found — check page.tsx manually"
tsx = tsx.replace(old_open, new_open)

# 3) wire the scan icon's onClick to open the prompt
old_scan_click = '''            onClick={() => {
              // TODO: trigger camera permission flow
            }}'''
new_scan_click = '''            onClick={() => setShowCameraPrompt(true)}'''

assert old_scan_click in tsx, "scan onClick not found — check page.tsx manually"
tsx = tsx.replace(old_scan_click, new_scan_click)

# 4) wire the gallery icon's onClick to open the hidden file input
old_gallery_click = '''            onClick={() => {
              // TODO: trigger gallery file picker
            }}'''
new_gallery_click = '''            onClick={() => galleryInputRef.current?.click()}'''

assert old_gallery_click in tsx, "gallery onClick not found — check page.tsx manually"
tsx = tsx.replace(old_gallery_click, new_gallery_click)

# 5) insert the camera permission box right after the scan callout div
old_scan_callout_close = '''            ALLOW A.I.
            <br />
            TO SCAN YOUR FACE
          </div>'''
new_scan_callout_close = '''            ALLOW A.I.
            <br />
            TO SCAN YOUR FACE
          </div>
          {showCameraPrompt && (
            <div className={styles.cameraPrompt}>
              <div className={styles.cameraPromptTitle}>
                ALLOW A.I. TO ACCESS YOUR CAMERA
              </div>
              <div className={styles.cameraPromptFooter}>
                <button
                  className={styles.denyBtn}
                  onClick={() => setShowCameraPrompt(false)}
                >
                  DENY
                </button>
                <button className={styles.allowBtn} onClick={requestCamera}>
                  ALLOW
                </button>
              </div>
            </div>
          )}'''

assert old_scan_callout_close in tsx, "scan callout close not found — check page.tsx manually"
tsx = tsx.replace(old_scan_callout_close, new_scan_callout_close)

# 6) hidden file input for gallery, right before the closing </div> of the gallery option
old_gallery_callout_close = '''            ALLOW A.I.
            <br />
            ACCESS GALLERY
          </div>
        </div>'''
new_gallery_callout_close = '''            ALLOW A.I.
            <br />
            ACCESS GALLERY
          </div>
          <input
            ref={galleryInputRef}
            type="file"
            accept="image/*"
            style={{ display: "none" }}
            onChange={handleGalleryFile}
          />
        </div>'''

assert old_gallery_callout_close in tsx, "gallery callout close not found — check page.tsx manually"
tsx = tsx.replace(old_gallery_callout_close, new_gallery_callout_close)

with open(path, "w") as f:
    f.write(tsx)

print("Patched", path)
PYEOF

# 7) add the camera prompt styles to result.module.css
cat >> src/app/result/result.module.css << 'EOF'

.cameraPrompt {
  position: absolute;
  z-index: 3;
  left: 118px;
  top: 160px;
  width: 350px;
  background: #1a1a1a;
  color: #ffffff;
  padding: 16px 18px;
}

.cameraPromptTitle {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.02em;
  line-height: 1.5;
  padding-bottom: 14px;
}

.cameraPromptFooter {
  display: flex;
  justify-content: flex-end;
  gap: 24px;
  padding-top: 12px;
  border-top: 1px solid rgba(255, 255, 255, 0.15);
}

.denyBtn,
.allowBtn {
  background: none;
  border: none;
  font-family: inherit;
  font-size: 11px;
  letter-spacing: 0.05em;
  cursor: pointer;
  padding: 0;
}

.denyBtn {
  color: #8a8a85;
}

.allowBtn {
  color: #ffffff;
  font-weight: 700;
}
EOF

echo "Done. Refresh localhost:3000/result and click the scan icon."
