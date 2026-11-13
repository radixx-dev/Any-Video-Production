---
name: pipeline
description: "The end-to-end chain for this repo: research a niche or take a topic, draft the script, humanise it, score the hook, check the source, direct the film in a Lemo-Opuscar style, render it in code, design sound with earshot, check, then caption and post. Use when asked to make a film, reel, short or explainer, or when asked for the next video in the usual flow."
argument-hint: "[topic or niche] [style name or slug]"
---

# Any-Video-Production pipeline

Twelve stages. Each one writes a file the next one reads; nothing skips its check.
The engine is Lemo-Opuscar (`skills/lemo-opuscar` → library at `$LIB`), the rules are in
`AGENTS.md`, and every command below is a wrapper in `bin/`.

```
LIB=${LEMO_OPUSCAR_HOME:-$HOME/lemo-opuscar}
```

## 0. Inputs

Topic or niche; the style (a Lemo name in English or Chinese, or a folder slug); format
(16:9 1920×1080 30 fps default, 1080×1920 on request). Ask once, in one message, and never again.

## 1. Research — `research`

```bash
./bin/research.sh status                 # redacted session check
./bin/research.sh login                  # only if there is no session
./bin/research.sh swipe a,b,c --limit 24 --min 3 --json > films/<name>/swipe.json
```

12 accounts, 50 posts each, ≥1.5 s apart, read-only. Stop on `rate_limited`, `checkpoint`,
`not_logged_in` and report the hint. Classify each outlier against
`skills/instagram-content/scripts/hooks.json` (26 formulas); for the top 2–3 read
`media` and `comments` to see why they spread.

**Out:** `swipe.md` — patterns, outliers ranked by multiple over their own median, 3–5 directions.

## 2. Idea

Score the directions on **multiple**, **repeatability** (same formula on 2+ accounts) and **fit**
(true in the client's voice, with a checkable source). Pick one, record it and the rejects.

## 3. Script — to one person

Full warm sentences, one idea per screen, one citation per screen (`SAHIH AL-BUKHARI 6406`).
Shape it before writing: pick one structure (question → evidence → answer, two lives compared,
count → verdict, reveal order). No engagement bait.

## 4. Humanise — `skills/humanizer`

Run the draft through the humanizer before anything else touches it: kill not-X-but-Y contrasts,
one-line closers, staged openers, forced triads, dash spam, stock AI words, bold labels, filler.
It changes the writing, never the facts. Keep the citation text and proper nouns verbatim.

**Out:** the script as it will be spoken and set on screen.

## 5. Hook — `hook`

Three candidates from three different formulas, scored:

```bash
./bin/hook.sh --hook "Proposals used to take me five hours"
./bin/hook.sh --hook "candidate" --json
```

Take the highest score, then fix the weakest axis the report names (usually stakes). On top of the
score: no riddle, no scare, nothing the source can't back, sayable in ≤2.5 s, ≤5 words per line.

## 6. Source check

Facts, hadith, ayah, study, number → primary page, quoted verbatim, URL recorded in
`TREATMENT.md` under Sources. Unsupported lines go back to the client.

## 7. Style and treatment — `skills/lemo-opuscar`

1. `$LIB/styles/README.md` → find the slug.
2. `$LIB/styles/<slug>/STYLE.md` → the fixed invariants; keep all of it.
3. `$LIB/DIRECTOR.md` §1–§5 → brief, benchmark, story, treatment.
4. Write `TREATMENT.md` (template in `templates/film/`) **before** opening the demo. The demo
   teaches technique only; at least four of six structural choices must differ from it.
5. Prove the look with real frames, not mock-ups:

```bash
./bin/render.sh still films/<name> 1.5 3 5
```

Check them against `STYLE.md`, then show 2–3 stills to the client when the look is being chosen.

## 8. Build and render

```bash
./bin/render.sh readcheck films/<name>
./bin/render.sh events    films/<name>
./bin/render.sh video     films/<name>            # adds --fps 30 by default
./bin/render.sh mux       films/<name>/out/video.mp4 films/<name>/mix.wav films/<name>/<name>.mp4 30 2
```

Everything visible is a pure function of `t` (`window.render(t)`, `window.DUR`, `window.READY`,
optional `window.TEXTS(t)`). No `Date.now()`, no unseeded random, no timers.

## 9. Voice

```bash
cd "$LIB"
.venv/bin/python core/tts/tts.py lines.json out/           # Kokoro, offline
.venv/bin/python core/tts/asr_check.py lines.json out/     # every line must transcribe back
```

No narration? Skip both and say so in the treatment.

## 10. Sound — `sfx` + foley

```bash
./bin/sfx.sh sfx list                    # ids, duration, peak
./bin/sfx.sh sfx render cut_hit/punch -o films/<name>/sfx/punch.wav
./bin/sfx.sh measure films/<name>/<name>.mp4
```

One sound per visible action, matched to material. **No music** — voice plus foley only. Effect
peaks within ~8 dB of the voice peak, peak one frame after the picture move. Build `mix.wav`, then
`mux.sh` masters it to −14 LUFS. Report the measured number; audio is measured, never "sounds fine".

## 11. Check

- `readcheck` exit 0 — every text held long enough.
- `./bin/render.sh sheet` contact sheet looked at; 0.2 s strips of key actions; no blank/NaN frames.
- Loudness printed by `mux.sh` and recorded in `CREDITS` or the delivery note.
- `grep -rniE "lemo ?lab|opus 5\.5" films/<name>` → only `LICENSE`, `CREDITS`, `LIB=`.

## 12. Deliver and post

In the film folder: `<name>.mp4`, `poster.jpg`, `.srt` if narrated, `TREATMENT.md`, `CREDITS`,
source with `build.sh`.

```bash
./bin/research.sh post films/<name>/<name>.mp4 --caption "…"                 # dry run
./bin/research.sh post films/<name>/<name>.mp4 --caption "…" --confirm --account <user>
```

One approval, one post. After 48 h the numbers go into the treatment as one rule for the next film.

## Overrides that win over every style

| Rule | Effect |
|---|---|
| Minecraft font | all on-screen lettering, whatever `STYLE.md` names |
| No music | voice + foley only; skip the music tier |
| No faces / human figures | objects, silhouettes, the mascot |
| Clawd in the performance | canonical asset, never redrawn or recoloured |
| No engagement-bait CTA | end on the thought |
| 16:9 1920×1080 30 fps | Lemo defaults to 24 — `bin/render.sh` passes 30 |
| Structural beat every 2–3 s | count cuts and re-layouts, not glow |
