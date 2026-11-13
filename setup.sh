#!/usr/bin/env bash
# Bootstraps Any-Video-Production: checks the toolchain, fetches the Lemo library and its render
# tier, and optionally builds the earshot Python env from the vendored source.
#
#   ./setup.sh              tools + Lemo library + render tier
#   ./setup.sh --check      report only, install nothing
#   ./setup.sh --with-voice adds the Lemo voice tier (TTS + speech check, ~1 GB models)
#   ./setup.sh --with-sfx   builds vendor/earshot/.venv (pulls torch; minutes, ~2 GB)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK_ONLY=0; WITH_VOICE=0; WITH_SFX=0
for a in "$@"; do
  case "$a" in
    --check) CHECK_ONLY=1 ;;
    --with-voice) WITH_VOICE=1 ;;
    --with-sfx) WITH_SFX=1 ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown flag: $a" >&2; exit 2 ;;
  esac
done

ok=0; bad=0
say() { printf '%s\n' "$*"; }
pass() { printf '  ok    %s\n' "$*"; ok=$((ok+1)); }
fail() { printf '  MISS  %s\n' "$*"; bad=$((bad+1)); }

say "== toolchain =="
if command -v node >/dev/null; then
  major="$(node -p 'process.versions.node.split(".")[0]')"
  if [ "$major" -ge 20 ]; then pass "node $(node -v)"; else fail "node $(node -v) — need >= 20 (22 recommended)"; fi
else fail "node (>= 20)"; fi
if command -v python3 >/dev/null; then
  py="$(python3 -c 'import sys;print("%d.%d"%sys.version_info[:2])')"
  case "$py" in 3.1[1-9]) pass "python $py";; *) fail "python $py — need >= 3.11";; esac
else fail "python3 (>= 3.11)"; fi
if command -v ffmpeg >/dev/null; then
  ff="$(ffmpeg -version 2>/dev/null | sed -n '1s/^ffmpeg version n\{0,1\}\([0-9]*\).*/\1/p')"
  if [ "${ff:-0}" -ge 7 ] 2>/dev/null; then pass "ffmpeg $ff.x"; else fail "ffmpeg ${ff:-?}.x — need >= 7"; fi
else fail "ffmpeg (>= 7)"; fi
command -v git >/dev/null && pass "git $(git --version | cut -d' ' -f3)" || fail "git"
command -v npx >/dev/null && pass "npx (bun on demand)" || fail "npx"
command -v uv >/dev/null && pass "uv $(uv --version 2>/dev/null | cut -d' ' -f2)" || say "  note  uv absent (optional; venvs use python -m venv)"

sleep 0

say ""
say "== Lemo-Opuscar engine =="
LEMO_SKILL="$ROOT/skills/lemo-opuscar/scripts/setup.sh"
if [ "$CHECK_ONLY" = 1 ]; then
  if [ -f "$HOME/lemo-opuscar/AGENTS.md" ]; then pass "library at ~/lemo-opuscar"
  else fail "library not fetched (run ./setup.sh)"; fi
else
  sh "$LEMO_SKILL"
  if [ "$WITH_VOICE" = 1 ]; then sh "$LEMO_SKILL" deps voice; else sh "$LEMO_SKILL" deps; fi
fi

say ""
say "== earshot (SFX) =="
EARSHOT_VENV="$ROOT/vendor/earshot/.venv/bin/earshot"
if [ -x "$EARSHOT_VENV" ]; then pass "vendor/earshot/.venv"
elif [ -x "$ROOT/../earshot/.venv/bin/earshot" ]; then pass "reusing a sibling earshot install"
elif [ "$WITH_SFX" = 1 ] && [ "$CHECK_ONLY" = 0 ]; then
  say "  installing earshot from GitHub into vendor/earshot/.venv (torch download, several minutes)…"
  mkdir -p "$ROOT/vendor/earshot"
  python3 -m venv "$ROOT/vendor/earshot/.venv"
  "$ROOT/vendor/earshot/.venv/bin/python" -m pip install --quiet --upgrade pip
  "$ROOT/vendor/earshot/.venv/bin/python" -m pip install --quiet \
    "earshot @ git+https://github.com/Leonxlnx/earshot@591fa3e028032e6dce56620a20e932e35667e8d8"
  pass "earshot installed (pinned 591fa3e0)"
else
  say "  note  not built; SFX falls back to the Lemo foley kit (core/audio/sfx.py)"
  say "        build it later with ./setup.sh --with-sfx"
fi

say ""
say "== result =="
say "  $ok checks passed, $bad missing"
[ "$bad" -eq 0 ] || { say "  fix the MISS lines above before the first render"; exit 1; }
say "  next: ./bin/hook.sh --hook \"your line\"   ·   skills/pipeline/SKILL.md"
