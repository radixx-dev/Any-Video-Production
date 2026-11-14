#!/usr/bin/env bash
# Build the 10 s foley mix from earshot's bank: ./build-mix.sh
# One cue per structural beat (0, 2, 4, 6, 8) plus two quiet ticks, bus-compressed, then mastered
# by mux.sh to −14 LUFS.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
dir="sfx/earshot"
[ -d "$dir" ] || { echo "no cue set: $dir (render the cues first, see README)" >&2; exit 1; }
mkdir -p mix

cues=("$dir/punch.wav:0:1.0" "$dir/whoosh.wav:2:0.85" "$dir/sub.wav:4:0.95" \
      "$dir/tick.wav:6:0.80" "$dir/air.wav:8:0.90" "$dir/hover.wav:1:0.35" "$dir/soft.wav:7:0.30")

args=(); filter=""; n=0
for c in "${cues[@]}"; do
  f="${c%%:*}"; rest="${c#*:}"; at="${rest%%:*}"; g="${rest##*:}"
  [ -f "$f" ] || { echo "missing cue $f" >&2; exit 1; }
  args+=(-i "$f")
  ms=$(python3 -c "print(int(float('$at')*1000))")
  filter+="[$n:a]volume=$g,adelay=${ms}|${ms}[a$n];"
  n=$((n+1))
done
mixin=""; for i in $(seq 0 $((n-1))); do mixin+="[a$i]"; done

ffmpeg -y -v error "${args[@]}" \
  -filter_complex "${filter}${mixin}amix=inputs=$n:normalize=0:duration=longest,volume=${MIX_GAIN:--3dB},acompressor=threshold=-26dB:ratio=5:attack=6:release=160:makeup=11dB,alimiter=limit=0.72:level=false,apad=whole_dur=10,atrim=0:10[out]" \
  -map "[out]" -ar 48000 -ac 2 "mix/mix.wav"

echo "built mix/mix.wav ($n earshot cues, 10 s)"
