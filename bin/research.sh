#!/usr/bin/env bash
# Instagram research through the user's own browser session (no Apify, no API keys).
#   ./bin/research.sh status
#   ./bin/research.sh login
#   ./bin/research.sh swipe acct1,acct2,acct3 --limit 24 --min 3 --json > swipe.json
#   ./bin/research.sh posts <username> --limit 24
#   ./bin/research.sh media <url>   |   comments <url> --limit 20   |   hashtag <tag>
# Limits: 12 accounts, 50 posts each, >= 1.5 s apart, read-only. Stop on rate_limited/checkpoint.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="$ROOT/skills/instagram"
[ -f "$DIR/scripts/main.ts" ] || { echo "missing $DIR/scripts/main.ts" >&2; exit 1; }
cd "$DIR"
command -v npx >/dev/null || { echo "need npx (Node 20+)" >&2; exit 1; }
exec npx -y bun scripts/main.ts "$@"
