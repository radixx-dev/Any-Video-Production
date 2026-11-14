# 10-second sound test

A working example of the sound half of the pipeline: one short film, five structural beats,
seven cues from earshot's 252-sound bank, mastered with `mux.sh`.

| | |
|---|---|
| Picture | `index.html` — 300 frames, 1920×1080, 30 fps, 10 s, Minecraft type, Clawd present |
| Beats | 0 s · 2 s · 4 s · 6 s · 8 s, one screen each (`SOUND` `252` `FRAME` `SYNTH` `METER`) |
| Cues | `cut_hit/punch` · `fit/whoosh.short/bamboo_swish` · `cut_hit/sub` · `fit/tick/domino` · `cut_hit/air` · `hover_tick/air` · `click/soft` |
| Output | [`sound-test.mp4`](sound-test.mp4) — 552 KB, h264 + AAC, −15.4 LUFS, peak −1.4 dBTP |

## Rebuild it

```bash
cd films/sound-test

# 1 · the picture
node "$HOME/lemo-opuscar/core/render/readcheck.mjs" .    # every text held long enough
node "$HOME/lemo-opuscar/core/render/video.mjs" . --fps 30 --workers 4

# 2 · the cues, straight from the bank
for c in "cut_hit/punch:punch" "fit/whoosh.short/bamboo_swish:whoosh" "cut_hit/sub:sub" \
         "fit/tick/domino:tick" "cut_hit/air:air" "hover_tick/air:hover" "click/soft:soft"; do
  ../../../bin/sfx.sh sfx render "${c%%:*}" -o "sfx/earshot/${c##*:}.wav"
done

# 3 · the mix, then the master
./build-mix.sh
cd ../.. && ./bin/render.sh mux films/sound-test/out/video.mp4 films/sound-test/mix/mix.wav \
                              films/sound-test/sound-test.mp4 30 2
```

## What it measures

| Metric | Value | Note |
|---|---|---|
| Sub band | −14.8 dB | real weight under the impacts |
| Brightness | 3492 Hz | material, not hiss |
| Attack | 38 ms | damped, not a click |
| Integrated | −15.4 LUFS | **1.4 LU under the −14 target** |
| True peak | −1.4 dBTP | why: seven sparse impacts, LRA 12.9, limiter-bound |

## Honest gaps

- The mix misses −14 LUFS by 1.4 LU. Sparse foley with silence between the hits has a huge crest
  factor, so `loudnorm` hits the true-peak ceiling before it reaches the target and `mux.sh` warns.
  A denser mix or heavier limiting would close it; a different library would not.
- `readcheck` rejected the first headlines (1.8 s on screen, 2.1 s needed) and they were shortened to
  one word each before this render.
- Nobody listened to this film. Every figure above is a measurement.
