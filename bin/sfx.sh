#!/usr/bin/env bash
# earshot: the SFX bank and the sound judgement tools.
#   ./bin/sfx.sh sfx list                      # 250+ sounds, id / duration / peak / pitch
#   ./bin/sfx.sh sfx render <id> -o out.wav
#   ./bin/sfx.sh measure <film.mp4>
#   ./bin/sfx.sh timeline <film.mp4> -o cues.json
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pick() { for c in "$@"; do [ -n "$c" ] && [ -x "$c" ] && { echo "$c"; return 0; }; done; return 1; }
BIN="$(pick \
  "${EARSHOT_BIN:-}" \
  "$ROOT/vendor/earshot/.venv/bin/earshot" \
  "$ROOT/../earshot/.venv/bin/earshot" \
  "$(command -v earshot 2>/dev/null || true)" || true)"

if [ -z "$BIN" ]; then
  cat >&2 <<'MSG'
earshot is not installed yet.
  build it from the vendored source:  ./setup.sh --with-sfx
  or point at an existing install:    EARSHOT_BIN=/path/to/earshot ./bin/sfx.sh sfx list
Until then, foley can come from Lemo's own kit: core/audio/sfx.py (click/whoosh/thump/ding…).
MSG
  exit 1
fi
exec "$BIN" "$@"
