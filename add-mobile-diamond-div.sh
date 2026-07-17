#!/bin/bash
set -e

FILE="src/app/page.tsx"

python3 - "$FILE" <<'PYEOF'
import sys
path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old = '''      <main className={styles.main}>
'''

new = '''      <main className={styles.main}>
        <div className={styles.mobileDiamond} />
'''

if old in content:
    content = content.replace(old, new, 1)
    print("page.tsx: mobileDiamond div inserted")
else:
    print("ERROR: <main> opening line not found — no change made")
    sys.exit(1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "Done. Review with: git diff $FILE"
