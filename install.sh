#!/usr/bin/env bash
# Alias for setup.sh — kept so `./install.sh` works as expected.
#   ./install.sh            tools + Lemo library + render tier
#   ./install.sh --check    report only
#   ./install.sh --with-sfx build the earshot env too
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec sh "$DIR/setup.sh" "$@"
