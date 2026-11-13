#!/usr/bin/env bash
# Lemo-Opuscar render tools, run from the library root against a film project folder.
#   ./bin/render.sh still     <film> 1.5 3 5      review JPEGs in <film>/stills
#   ./bin/render.sh video     <film> [--fps 30] [--workers 4]
#   ./bin/render.sh events    <film>              cue/sound events → <film>/events.json
#   ./bin/render.sh readcheck <film>              every on-screen text held long enough
#   ./bin/render.sh mux       <video.mp4> <mix.wav> <out.mp4> [fps] [grain]
#   ./bin/render.sh sheet     <out.jpg> <img...>
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB="${LEMO_OPUSCAR_HOME:-$HOME/lemo-opuscar}"
[ -f "$LIB/AGENTS.md" ] && [ -d "$LIB/core/render" ] || {
  echo "Lemo library not found at $LIB — run ./setup.sh (or set LEMO_OPUSCAR_HOME)" >&2; exit 1; }

# absolutise before cd: the tools run from $LIB and reject a moving relative path
abs() { case "$1" in /*|[A-Za-z]:[/\\]*) printf '%s' "$1" ;;
        *) printf '%s/%s' "$(cd "$(dirname "$1")" 2>/dev/null && pwd || echo "$PWD")" "$(basename "$1")" ;; esac; }

cmd="${1:-}"; shift || true
[ $# -ge 1 ] || { sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

case "$cmd" in
  still|video|events|readcheck)
    film="$(abs "$1")"; shift
    [ -f "$film/index.html" ] || { echo "no index.html in $film" >&2; exit 2; }
    case "$cmd" in
      still)     cd "$LIB"; exec node core/render/still.mjs    "$film" "$@" ;;
      events)    cd "$LIB"; exec node core/render/events.mjs   "$film" "$@" ;;
      readcheck) cd "$LIB"; exec node core/render/readcheck.mjs "$film" "$@" ;;
      video)
        args=(); for a in "$@"; do args+=("$a"); done
        case " ${*:-} " in *" --fps "*) ;; *) args=(--fps 30 "${args[@]}") ;; esac
        cd "$LIB"; exec node core/render/video.mjs "$film" "${args[@]}" ;;
    esac ;;
  mux)
    [ $# -ge 3 ] || { echo "mux needs <video.mp4> <mix.wav> <out.mp4> [fps] [grain]" >&2; exit 2; }
    v="$(abs "$1")"; a="$(abs "$2")"; o="$(abs "$3")"; shift 3
    fps="${1:-30}"; grain="${2:-2}"
    cd "$LIB"; exec sh core/render/mux.sh "$v" "$a" "$o" "$fps" "$grain" ;;
  sheet)
    [ $# -ge 2 ] || { echo "sheet needs <out.jpg> <img...>" >&2; exit 2; }
    o="$(abs "$1")"; shift; imgs=()
    for i in "$@"; do imgs+=("$(abs "$i")"); done
    cd "$LIB"; exec .venv/bin/python core/render/sheet.py "$o" "${imgs[@]}" ;;
  *) echo "unknown command: $cmd" >&2; sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac
