#!/usr/bin/env bash
# Build a 10 s mix from one cue set: ./build-mix.sh earshot | librosa
# Places a cue at each structural beat (0, 2, 4, 6, 8) plus two ticks, then normalises the sum.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
src="${1:-earshot}"
dir="sfx/$src"
[ -d "$dir" ] || { echo "no such cue set: $dir" >&2; exit 1; }
mkdir -p mix

case "$src" in
  earshot) cues=("$dir/punch.wav:0:1.0" "$dir/whoosh.wav:2:0.85" "$dir/sub.wav:4:0.95" \
                 "$dir/tick.wav:6:0.80" "$dir/air.wav:8:0.90" "$dir/hover.wav:1:0.35" "$dir/soft.wav:7:0.30") ;;
  librosa) cues=("$dir/01-impact.wav:0:1.0" "$dir/02-whoosh.wav:2:0.85" "$dir/03-sub.wav:4:0.95" \
                 "$dir/04-tick.wav:6:0.80" "$dir/05-air.wav:8:0.90") ;;
  *) echo "unknown cue set: $src" >&2; exit 2 ;;
esac

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
  -map "[out]" -ar 48000 -ac 2 "mix/mix-$src.wav"

echo "built mix/mix-$src.wav ($n cues, 10 s)"
ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "mix/mix-$src.wav"
