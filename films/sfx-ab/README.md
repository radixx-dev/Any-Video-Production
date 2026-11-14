# SFX A/B: earshot vs librosa

**Question.** Can [librosa](https://github.com/librosa/librosa) replace [earshot](https://github.com/Leonxlnx/earshot)
as this repo's sound engine?

**Answer.** No — and the test says why, measured rather than guessed. librosa is an audio
**analysis and DSP** library (ISC). earshot is a curated **sound bank plus judgement tools** (MIT).
They are not the same category, and earshot already depends on librosa 1.0.0 internally.

## Method

One picture, two mixes, identical cue times (0, 2, 4, 6, 8 s, plus two quiet ticks in A).

| | Picture | Cues |
|---|---|---|
| **A · earshot** | `index.html`, 300 frames, 1920×1080, 30 fps, 10 s | 7 sounds rendered from the 252-sound bank: `cut_hit/punch`, `fit/whoosh.short/bamboo_swish`, `cut_hit/sub`, `fit/tick/domino`, `cut_hit/air`, `hover_tick/air`, `click/soft` |
| **B · librosa-only** | same render, same cue times | 5 sounds built from **white noise and sine sweeps only**, then shaped by `librosa.effects.hpss`, `pitch_shift`, `time_stretch`, `preemphasis` — no sample, no bank, nothing borrowed from earshot |

Both mixes: `amix` at the cue times → bus compression → limiter → `mux.sh` (loudnorm to −14 LUFS),
then measured with `earshot measure`. Reproduce with `./build-mix.sh earshot` / `./build-mix.sh librosa`
and `../earshot/.venv/bin/python make-librosa-sfx.py`.

## Measured

| Metric | A · earshot bank | B · librosa synth | Read |
|---|---|---|---|
| Cue count available | **252** (`sfx list`) | **0** — every sound is authored by hand | the whole difference |
| Integrated loudness | −15.4 LUFS | −14.4 LUFS | B easier to master: fewer, longer sounds |
| True peak | −1.4 dBTP | −2.0 dBTP | — |
| LRA | 12.9 LU | 7.0 LU | A has real transient/decay contrast |
| Sub band (−13 dB ref) | **−14.8 dB** | −22.5 dB | **A carries 7.7 dB more weight** |
| Top band | −14.0 dB | **−7.9 dB** | B is 6.1 dB hissier |
| Brightness (centroid) | 3492 Hz | **10916 Hz** | B is 3× brighter — noise, not material |
| Attack | 38 ms | 11 ms | B clicks; A has body |
| realness p_real | 0.05 | 0.07 | **both read as code-synthesised** |

## What the numbers mean

1. **librosa has no sounds.** `sfx list` is the entire workflow: 252 named, material-aware cues in
   one command. With librosa, a "punch" is a design project — noise burst, HPSS split, pitch shift,
   envelope — and it still lands 7.7 dB lighter in the sub and 6.1 dB brighter than the bank cue.
2. **The realness classifier does not pick a winner.** Both mixes score as synthesised, because
   earshot's bank is procedurally *forged* rather than recorded. So "is it real?" is the wrong test;
   the right one is whether it has weight, damping and material, which is what the band numbers show.
3. **The differentiator is judgement, not DSP.** earshot also answers `describe`, `match`, `rank`,
   `find`, `compare`, `ab`, `timeline` and `measure` — choosing and verifying a cue. librosa gives you
   `onset`, `beat`, `feature`: excellent for aligning cues to picture, useless for inventing a punch.
4. **Both are cheap.** Picture: 300 frames in ~10 s wall at 4 workers. Cues: earshot 7 renders in under
   a second; the librosa set took five hand-written synth recipes.

## Decision

Keep **earshot** as the sound engine. Keep **librosa** as a dependency it already brings
(useful for onset detection when a cue must land on a frame boundary). No replacement.

## Honest gaps in this test

- The sparse foley-only mix is **peak-limited**: 7 impacts with silence between give LRA 12.9, so
  `mux.sh` reached −15.4 LUFS instead of the −14 target and warned. Hitting −14 would need heavier
  limiting or a denser mix, not a different library.
- `realness` windows are 4 s and the whole test is 10 s; judge stems as well as mixes for a stronger read.
- Nobody listened to either film. The comparison is measurement and metadata, as this repo requires.
- `readcheck` rejected the first pass of headlines (1.8 s on screen, 2.1 s needed); they were shortened
  to one word each before the render that produced these numbers.
