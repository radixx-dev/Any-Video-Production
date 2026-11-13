#!/usr/bin/env bash
# Score a hook on length, specificity, stakes and frontload (MIT scorer, 26 formulas alongside).
#   ./bin/hook.sh --hook "Proposals used to take me five hours"
#   ./bin/hook.sh --hook "line" --json
#   ./bin/hook.sh hooks.txt            # one candidate per line
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCORER="$ROOT/skills/instagram-content/scripts/hook-score.ts"
[ -f "$SCORER" ] || { echo "missing $SCORER" >&2; exit 1; }

if command -v bun >/dev/null; then
  exec bun "$SCORER" "$@"
elif command -v npx >/dev/null; then
  exec npx -y bun "$SCORER" "$@"
else
  echo "need bun or npx: install Node 20+ (bun is fetched by npx)" >&2
  exit 1
fi
