#!/usr/bin/env bash
# One-command build for this film. Run from the film folder: ./build.sh [still|video|mux|all]
set -euo pipefail
FILM="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="${LEMO_OPUSCAR_HOME:-$HOME/lemo-opuscar}"
NAME="$(basename "$FILM")"
do="${1:-all}"

[ -d "$LIB/core/render" ] || { echo "Lemo library missing at $LIB — run ../../setup.sh" >&2; exit 1; }

case "$do" in
  still)
    cd "$LIB" && node core/render/still.mjs "$FILM" 1.5 3 5 --out "$FILM/stills"
    ;;
  video)
    cd "$LIB" && node core/render/readcheck.mjs "$FILM"
    cd "$LIB" && node core/render/events.mjs "$FILM"
    cd "$LIB" && node core/render/video.mjs "$FILM" --fps 30 --workers 4 --out "$FILM/out/video.mp4"
    ;;
  mux)
    [ -f "$FILM/mix.wav" ] || { echo "no mix.wav yet — design sound first (bin/sfx.sh)" >&2; exit 1; }
    cd "$LIB" && sh core/render/mux.sh "$FILM/out/video.mp4" "$FILM/mix.wav" "$FILM/$NAME.mp4" 30 2
    ;;
  all)
    "$0" video
    [ -f "$FILM/mix.wav" ] && "$0" mux || echo "picture done: $FILM/out/video.mp4 (no mix.wav yet)"
    ;;
  *) echo "usage: ./build.sh [still|video|mux|all]" >&2; exit 2 ;;
esac
