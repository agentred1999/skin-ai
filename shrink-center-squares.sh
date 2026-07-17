#!/bin/bash
set -e
cd "$(dirname "$0")"

cat > src/app/page.module.css << 'EOF'
.page {
  position: relative;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  padding: 2rem 3rem;
  overflow: hidden;
}

.header {
  position: relative;
  z-index: 2;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logoGroup {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.logo {
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.05em;
  border: 1px solid var(--color-black);
  padding: 0.35rem 0.75rem;
}

.introTag {
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.05em;
  color: var(--color-gray);
}

.enterCodeButton {
  padding: 0.7rem 1.35rem;
  border-radius: 999px;
  background-color: var(--color-black);
  color: var(--color-white);
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  transition: opacity 0.2s ease;
}

.enterCodeButton:hover {
  opacity: 0.8;
}

.main {
  position: relative;
  z-index: 2;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.headline {
  font-size: clamp(2.75rem, 7.5vw, 6rem);
  font-weight: 400;
  line-height: 1.05;
  letter-spacing: -0.02em;
  max-width: 900px;
}

.sideAction {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  gap: 0.85rem;
  z-index: 2;
}

.sideAction.left {
  left: 1.5rem;
}

.sideAction.right {
  right: 1.5rem;
  flex-direction: row-reverse;
}

.diamond {
  width: 44px;
  height: 44px;
  border: 1px solid var(--color-black);
  transform: rotate(45deg);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: background-color 0.2s ease;
}

.diamond span {
  display: inline-block;
  transform: rotate(-45deg);
  font-size: 0.7rem;
}

.sideAction:hover .diamond {
  background-color: var(--color-black);
  color: var(--color-white);
}

.sideActionLabel {
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  white-space: nowrap;
}

.footer {
  position: relative;
  z-index: 2;
}

.subtext {
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.03em;
  text-transform: uppercase;
  color: var(--color-black);
  max-width: 340px;
  line-height: 1.6;
}

.mobileDiamond {
  display: block;
  position: absolute;
  top: 50%;
  left: 50%;
  border: 1px solid rgba(0, 0, 0, 0.15);
  transform: translate(-50%, -50%) rotate(45deg);
  pointer-events: none;
  z-index: 0;
}

.mobileDiamond:first-of-type {
  width: 48vw;
  height: 48vw;
  max-width: 320px;
  max-height: 320px;
}

.mobileDiamond:last-of-type {
  width: 34vw;
  height: 34vw;
  max-width: 230px;
  max-height: 230px;
}

@media (max-width: 768px) {
  .page {
    padding: 1.5rem;
  }

  .mobileDiamond:first-of-type {
    width: 62vw;
    height: 62vw;
    max-width: 340px;
    max-height: 340px;
  }

  .mobileDiamond:last-of-type {
    width: 44vw;
    height: 44vw;
    max-width: 240px;
    max-height: 240px;
  }

  .sideAction.left,
  .sideAction.right {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    margin-top: 0;
  }
  .sideAction.left {
    left: 0;
  }
  .sideAction.right {
    right: 0;
  }

  .main {
    flex-direction: column;
    gap: 1.5rem;
  }
}
EOF

echo "Done — both center squares are smaller. Refresh localhost:3000 to see the change."
