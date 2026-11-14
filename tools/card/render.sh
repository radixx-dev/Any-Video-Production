#!/usr/bin/env bash
# Render all 100 style cards: 4 sheets of 25 at 3840×2160, sliced into styles/previews/*.jpg.
#   ./tools/card/render.sh            (needs the Lemo library from ./install.sh)
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LIB="${LEMO_OPUSCAR_HOME:-$HOME/lemo-opuscar}"
[ -d "$LIB/core/render" ] || { echo "Lemo library missing at $LIB — run ./install.sh" >&2; exit 1; }
mkdir -p "$ROOT/tools/card/sheets" "$ROOT/styles/previews"
rm -f "$ROOT"/tools/card/sheets/*.jpg
for s in 0 1 2 3; do
  ( cd "$LIB" && node core/render/still.mjs "$ROOT/tools/card" 0.1 --size 3840x2160 \
      --q "sheet=$s" --prefix "sheet$s" --out "$ROOT/tools/card/sheets" >/dev/null )
done
cd "$ROOT" && python3 tools/card/slice.py
echo "100 cards in styles/previews"
