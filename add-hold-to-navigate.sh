#!/bin/bash
set -e

TSX_FILE="src/app/page.tsx"
CSS_FILE="src/app/page.module.css"

python3 - "$TSX_FILE" "$CSS_FILE" <<'PYEOF'
import sys

tsx_path, css_path = sys.argv[1], sys.argv[2]

with open(tsx_path, "r") as f:
    tsx = f.read()

if "'use client'" not in tsx and '"use client"' not in tsx:
    tsx = '"use client";\n\n' + tsx
    print("page.tsx: added 'use client' directive")

if 'import { useRouter }' not in tsx:
    tsx = tsx.replace(
        'import Link from "next/link";',
        'import Link from "next/link";\nimport { useRouter } from "next/navigation";\nimport { useRef, useState } from "react";'
    )
    print("page.tsx: added router/state imports")

if "function HoldToNavigate" not in tsx:
    hold_component = '''
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

'''
    tsx = tsx.replace(
        "export default function Home() {",
        hold_component + "export default function Home() {"
    )
    print("page.tsx: HoldToNavigate component added")

old_left = '''        <Link href="/testing" className={`${styles.sideAction} ${styles.left}`}>
          <div className={styles.diamond}>
            <span>&#9664;</span>
          </div>
          <span className={styles.sideActionLabel}>Discover A.I.</span>
        </Link>'''
new_left = '''        <HoldToNavigate href="/testing" side="left" icon="\u25c0" label="Discover A.I." />'''

if old_left in tsx:
    tsx = tsx.replace(old_left, new_left)
    print("page.tsx: left nav converted to HoldToNavigate")

old_right = '''        <Link href="/testing" className={`${styles.sideAction} ${styles.right}`}>
          <div className={styles.diamond}>
            <span>&#9654;</span>
          </div>
          <span className={styles.sideActionLabel}>Take Test</span>
        </Link>'''
new_right = '''        <HoldToNavigate href="/testing" side="right" icon="\u25b6" label="Take Test" />'''

if old_right in tsx:
    tsx = tsx.replace(old_right, new_right)
    print("page.tsx: right nav converted to HoldToNavigate")

with open(tsx_path, "w") as f:
    f.write(tsx)

with open(css_path, "r") as f:
    css = f.read()

if ".diamondFill" not in css:
    css += """

.diamond {
  position: relative;
  overflow: hidden;
}

.diamondIcon {
  position: relative;
  z-index: 1;
  display: inline-block;
  transform: rotate(-45deg);
  font-size: 0.7rem;
}

.diamondFill {
  position: absolute;
  inset: 0;
  background-color: var(--color-black);
  transform: scaleY(0);
  transform-origin: bottom;
  transition: transform 0s linear;
  z-index: 0;
}

.diamondFilling {
  transform: scaleY(1);
  transition: transform 0.8s linear;
}

.diamondFilling ~ .diamondIcon,
.sideAction:has(.diamondFilling) .diamondIcon {
  color: var(--color-white);
}
"""
    with open(css_path, "w") as f:
        f.write(css)
    print("page.module.css: diamond fill animation styles added")
else:
    print("page.module.css: diamondFill styles already present, skipping")
PYEOF

echo "Done. Review with: git diff $TSX_FILE $CSS_FILE"
