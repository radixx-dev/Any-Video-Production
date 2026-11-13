# The chain, stage by stage

Every row: what goes in, the command, what comes out. `FILM=films/<name>`.

| # | Stage | In | Command | Out |
|---|---|---|---|---|
| 1 | Research | niche, 5–12 accounts or a tag | `./bin/research.sh swipe a,b,c --limit 24 --min 3 --json` | `$FILM/swipe.json` |
| 1b | Teardown | one winning reel | `skills/reel-analyzer` (agent reads it) | hook/format notes |
| 2 | Idea | swipe file | score multiple · repeatability · fit | `## Idea` in treatment |
| 3 | Script | idea + source | write, one idea per screen | draft script |
| 4 | Humanizer | draft | `skills/humanizer/SKILL.md` | humanised script |
| 5 | Hook | script | `./bin/hook.sh --hook "line"` | scores + the pick |
| 6 | Source | claims | primary page fetch, quoted | `## Sources` |
| 7 | Style | style name | `$LIB/styles/README.md` → `STYLE.md` | `TREATMENT.md` |
| 7b | Look | treatment | `./bin/render.sh still $FILM 1.5 3 5` | 3 real frames |
| 8 | Build | treatment | page contract (`templates/film/index.html`) | `$FILM/index.html` |
| 8b | Render | page | `./bin/render.sh readcheck $FILM` then `video` | `$FILM/out/video.mp4` |
| 9 | Voice | script lines | `core/tts/tts.py` + `asr_check.py` | wavs + word timings |
| 10 | Sound | picture + events | `./bin/sfx.sh sfx render <id> -o …` | `$FILM/sfx/*.wav` |
| 10b | Mix | voice + foley | `./bin/render.sh mux … 30 2` | `$FILM/<name>.mp4` at −14 LUFS |
| 11 | Check | film | readcheck, sheet, measure, grep | pass / fix list |
| 12 | Post | film + caption | `./bin/research.sh post … --confirm` | live post + 48 h numbers |

## Page contract (stage 8)

| Global | Required | Meaning |
|---|---|---|
| `window.READY = true` | yes | set once fonts and images are loaded |
| `window.render(t)` | yes | draw frame at second `t`, deterministic |
| `window.DUR` | video/readcheck | film length |
| `window.EV = [{t,type,…}]` | no | sound and cue events |
| `window.TEXTS(t)` | readcheck | `[{id,text,x0,y0,x1,y1}]`, full text from first visible frame |

## Defaults

16:9 1920×1080, 30 fps, −14 LUFS, true peak ≤ −1 dBTP, Minecraft type, no music, no faces,
Clawd present, no CTA. Vertical 1080×1920 only when asked (`--size 1080x1920`).

## Failure habits to avoid

- Animating before the board exists; a picture that changes only by glow.
- Copy that needs 6+ words on one line.
- SFX measured at −14 dBFS under a −2.6 dBFS voice and called done.
- A style's demo reused as the story instead of only its technique.
