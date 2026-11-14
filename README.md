<div align="center">

# Any-Video-Production

**A code-rendered film studio you can clone.**
Research a niche → write and humanise the script → score the hook → direct in one of 100 styles → draw every frame in code → design the sound → post it.

No video model. No editing timeline. No subscription.

[![License: MIT](https://img.shields.io/badge/license-MIT-2ea44f)](LICENSE)
[![Node](https://img.shields.io/badge/node-%E2%89%A520-339933?logo=nodedotjs&logoColor=white)](https://nodejs.org)
[![Python](https://img.shields.io/badge/python-%E2%89%A53.11-3776AB?logo=python&logoColor=white)](https://python.org)
[![FFmpeg](https://img.shields.io/badge/ffmpeg-%E2%89%A57-007808?logo=ffmpeg&logoColor=white)](https://ffmpeg.org)
[![Styles](https://img.shields.io/badge/styles-100-d97757)](https://github.com/lemomo-ai/lemo-opuscar)
[![SFX](https://img.shields.io/badge/sfx-252%20sounds-8a2be2)](https://github.com/Leonxlnx/earshot)
[![Engine stars](https://img.shields.io/github/stars/lemomo-ai/lemo-opuscar?label=lemo--opuscar)](https://github.com/lemomo-ai/lemo-opuscar)

[Quickstart](#quickstart) · [The five stages](#the-five-stages) · [Commands](#the-command-surface) · [Skills](#the-skills-in-this-repo) · [House rules](#house-rules) · [Troubleshooting](#troubleshooting) · [Credits](#credits)

</div>

---

## Why this exists

Most "AI video" tools rent you a model. You write a prompt, you get a clip you can't edit, in a style you can't repeat, at a resolution you didn't choose. The output is unrecognisable from the next person's, and every rerun is a new dice roll.

This repo takes the other route. A film is a **program**: HTML and Canvas rendered frame-by-frame in headless Chromium, blended and mixed, then encoded by ffmpeg. That means every frame is deterministic, every style is a reusable spec, and the only cost is your machine's time — a 15-second vertical reel renders in about 20 seconds.

Around that engine sit the four stages people actually get wrong: **what to make** (research), **what to say** (script + humanizer), **how to open** (a scored hook), and **how it sounds** (a real SFX bank with measurement). This repo wires all five together with one command each, and writes down the contracts between them.

## The five stages

| # | Stage | Backed by | Upstream | Licence |
|---|---|---|---|---|
| 1 | **Research** — what is working in your niche, ranked by outlier multiple over each account's own median | `skills/content-research`, `skills/instagram-research`, `skills/instagram`, `skills/reel-analyzer` | [Ootto-AI/claude-content-skills](https://github.com/Ootto-AI/claude-content-skills) · [proyecto26/instagram-ai-plugin](https://github.com/proyecto26/instagram-ai-plugin) | MIT |
| 2 | **Scripting** — a story to one person, then the AI tells stripped out | `skills/humanizer` + the engine's `DIRECTOR.md` | [blader/humanizer](https://github.com/blader/humanizer) · [lemomo-ai/lemo-opuscar](https://github.com/lemomo-ai/lemo-opuscar) | MIT |
| 3 | **Hook** — three candidates from three formulas, scored on five axes | `skills/instagram-content/scripts/` + `bin/hook.sh` | [proyecto26/instagram-ai-plugin](https://github.com/proyecto26/instagram-ai-plugin) (26 formulas, `hook-score.ts`) | MIT |
| 4 | **Video** — treatment, style, code, frames | `skills/lemo-opuscar` + `bin/render.sh` | [lemomo-ai/lemo-opuscar](https://github.com/lemomo-ai/lemo-opuscar) — **100 styles** | MIT AND CC-BY-NC-4.0 |
| 5 | **SFX** — one sound per visible action, measured, mixed | `skills/earshot` + `bin/sfx.sh` | [Leonxlnx/earshot](https://github.com/Leonxlnx/earshot) — **252 sounds** | MIT |

Two of those stages are judgement, not code: **picking the idea** (score multiple · repeatability · fit) and **checking the source** (primary page, quoted verbatim). The pipeline says how; no tool pretends to do it for you.

## Quickstart

```bash
git clone git@github.com:radixx-dev/Any-Video-Production.git
cd Any-Video-Production
./install.sh                    # same as ./setup.sh: checks tools, fetches the heavy parts
./setup.sh --check              # report only, installs nothing
```

Then, before you spend a minute on a film, prove each stage answers:

```bash
./bin/hook.sh --hook "Two words. Heavy on the scale."   # scores a hook
./bin/render.sh still templates/film 0.5 1.5            # two real frames, ~70 ms each
./bin/sfx.sh sfx list | head                            # the SFX bank
./bin/research.sh status                                # Instagram session, redacted
```

Point an agent at the folder and say *"make a film about X in Y style"*: it reads `skills/pipeline/SKILL.md` (the order of work) and `AGENTS.md` (the house rules), and drives the wrappers.

## How a film is made

```
topic / niche
    │
    ├─ 1  research ......... swipe file of outliers, formulas, comments       → swipe.md
    ├─ 2  idea ............  multiple · repeatability · fit                  → ## Idea
    ├─ 3  script ..........  one idea per screen, one citation per screen    → script draft
    ├─ 4  humanize ........  no AI tells, facts untouched                    → final script
    ├─ 5  hook ............  three formulas, five scores, weakest axis fixed → ## Hooks
    ├─ 6  source ..........  primary page, quoted verbatim                   → ## Sources
    ├─ 7  style ...........  STYLE.md invariants + treatment                 → TREATMENT.md
    ├─ 8  build ...........  window.render(t), pure function of time         → index.html
    ├─ 9  render ..........  readcheck → events → video.mjs → mux.sh         → film.mp4
    ├─ 10 voice ...........  Kokoro offline / edge-tts + ASR check            → out/*.wav
    ├─ 11 sound ...........  earshot SFX, measured, mixed to −14 LUFS        → mix.wav
    └─ 12 post ............  caption linted, dry run, confirm, 48 h numbers  → live
```

Every stage writes a file the next stage reads. Nothing skips its check, and nothing is "done" because it looked fine in a still.

## Repository map

```text
Any-Video-Production/
├── README.md                  this file
├── AGENTS.md                  the rules an agent must follow (craft + house style)
├── CREDITS.md                 every third-party component and its licence
├── LICENSE                    MIT (your code and docs)
├── setup.sh                   toolchain check · Lemo library · optional earshot env
│
├── bin/                       one command per stage
│   ├── research.sh            Instagram: status · login · swipe · posts · media · comments
│   ├── hook.sh                the 26-formula scorer
│   ├── render.sh              Lemo tools: still · video · events · readcheck · mux · sheet
│   └── sfx.sh                 earshot: sfx list · sfx render · measure · timeline
│
├── skills/
│   ├── pipeline/SKILL.md      the 12 stages, each with its command and contract
│   ├── instagram-research/    outlier research through your own browser session
│   ├── instagram/             the client: login, swipe, media, comments, post (dry run)
│   ├── instagram-content/     26 hook formulas, hook-score, caption-lint, beats, slop
│   ├── content-research/      a creator → outliers → playbook
│   ├── reel-analyzer/         frame-by-frame teardown of one winning reel
│   ├── humanizer/             strips the AI fingerprint from prose
│   ├── lemo-opuscar/          the engine's fetcher and hand-over
│   └── earshot/               how to judge, choose and verify sound
│
├── templates/film/            an empty film: page contract, build.sh, TREATMENT.md
├── docs/chain.md              stage → command → artefact, as a table
└── styles/README.md           choosing a style · external style libraries
```

**63 files, ~600 KB**, because the heavy parts are fetched, not committed.

## The command surface

### `bin/research.sh` — what is working

```bash
./bin/research.sh status                       # who is signed in (redacted lengths only)
./bin/research.sh login                        # opens Chrome, sign in, 2FA is fine
./bin/research.sh swipe a,b,c --limit 24 --min 3 --json > swipe.json
./bin/research.sh posts <username> --limit 30
./bin/research.sh media <url|shortcode>
./bin/research.sh comments <url> --limit 20
./bin/research.sh hashtag <tag> --limit 24
./bin/research.sh search "<query>"
./bin/research.sh post <media> --caption "…"                 # dry run: prints, sends nothing
./bin/research.sh post <media> --caption "…" --confirm --account <user>
```

Limits the CLI enforces: **12 accounts, 50 posts each, ≥1.5 s apart, read-only.** On `rate_limited`, `checkpoint` or `not_logged_in` it stops and reports the hint instead of retrying. No Apify, no API keys — your own session, your own account.

### `bin/hook.sh` — the opening line

```bash
./bin/hook.sh --hook "Proposals used to take me five hours"
./bin/hook.sh --hook "candidate" --json
```

Scores **length, specificity, stakes, frontload**, plus spoken time. The report names the weakest axis, so you fix that instead of rewriting blind.

### `bin/render.sh` — every frame

```bash
./bin/render.sh still     films/my-film 1.5 3 5                 # review JPEGs
./bin/render.sh readcheck films/my-film                          # is text held long enough?
./bin/render.sh events    films/my-film                          # cue map → events.json
./bin/render.sh video     films/my-film --fps 30 --workers 4     # frames → video
./bin/render.sh mux       films/my-film/out/video.mp4 \
                          films/my-film/mix.wav \
                          films/my-film/my-film.mp4 30 2         # master to −14 LUFS
./bin/render.sh sheet     contact.jpg films/my-film/stills/*.jpg
```

### `bin/sfx.sh` — sound you can measure

```bash
./bin/sfx.sh sfx list                          # 252 sounds: id, duration, peak, pitch
./bin/sfx.sh sfx render cut_hit/punch -o punch.wav
./bin/sfx.sh measure films/my-film/my-film.mp4
./bin/sfx.sh timeline films/my-film/my-film.mp4 -o cues.json
```

## The skills in this repo

| Skill | What it does | Upstream |
|---|---|---|
| `pipeline` | the 12 stages, contracts, overrides | this repo |
| `instagram-research` | outliers by multiple over own median; hook classification; swipe file | [proyecto26/instagram-ai-plugin](https://github.com/proyecto26/instagram-ai-plugin) |
| `instagram` | session client: read everything, publish with approval | same |
| `instagram-content` | 26 hook formulas, scorer, caption linter, beat builder | same |
| `content-research` | creator → outlier map → format playbook | [Ootto-AI/claude-content-skills](https://github.com/Ootto-AI/claude-content-skills) |
| `reel-analyzer` | frame-by-frame teardown of one reel | same |
| `humanizer` | removes AI tells without changing meaning | [blader/humanizer](https://github.com/blader/humanizer) |
| `lemo-opuscar` | fetches the engine library, then follows its `AGENTS.md` | [lemomo-ai/lemo-opuscar](https://github.com/lemomo-ai/lemo-opuscar) |
| `earshot` | listening, choosing, measuring and verifying sound | [Leonxlnx/earshot](https://github.com/Leonxlnx/earshot) |

## The engine: 100 styles

The style library is fetched on first run into `~/lemo-opuscar`. Each style is a `STYLE.md` of fixed invariants — look, colour, type, motion grammar, camera, sound palette, native moves, pitfalls — plus a demo film made entirely in code. Pick one, keep the invariants, direct the rest yourself.

| Family | Examples |
|---|---|
| Painting & illustration | Impasto Oil Painting · Watercolor Brush · Urban Sketch · Colored-Pencil Science |
| Sketch & board | Whiteboard Explainer · Chalkboard · Sketchnote · Marker on Paper · One-line Drawing |
| Traditional crafts | Chinese Ink Wash · Ukiyo-e · Red Paper-cut · Paper-cut Lightbox · Stained Glass |
| Print & printmaking | Halftone Dossier · Risograph · Woodcut · Copperplate · Silkscreen Travel |
| Graphic & type | Swiss Motion · 60s Spy Title · Art Deco · Bauhaus · Pictogram Motion |
| Line diagrams | Blueprint · Isometric Infographic · Exploded Teardown · Pen Plotter |
| Cartoons & games | 80s Cel Anime · Rubber Hose · 16-bit Pixel RPG · 2.5D Pixel |
| Film & tape | CRT ASCII · 1920s Silent · Liminal Found Footage · Double Exposure |
| Screens & instruments | Dark Tech Keynote · Hologram HUD · Satellite Briefing · LiDAR Survey · Security X-ray |

Styles marked `✦` draw characters or panels with an image generator and need one configured (`python3 core/image/gen_image.py --check`). Without it, that style cannot start — the repo says so before the brief rather than shipping a stand-in.

## Sound, not decoration

earshot ships a **252-sound** procedural bank plus the tooling to judge it: durations, transient peaks, pitch, kinds. The rules this repo enforces around it:

- **One sound per visible action**, matched to the material — paper, wood, metal, ink and glass do not sound alike.
- **Peaks within ~8 dB of the voice peak**, placed one frame after the picture move.
- **No music.** Voice and foley only.
- **Measured, never assumed.** `mux.sh` masters to −14 LUFS / ≤ −1 dBTP and prints the number; that number gets reported.

## House rules

From `AGENTS.md`, and they win over any style's own spec:

| Rule | Effect |
|---|---|
| Minecraft font | every on-screen letter, whatever the style names |
| No faces, no human figures | people become objects, silhouettes or the mascot |
| The mascot belongs in the performance | canonical asset, never redrawn or recoloured |
| No engagement-bait CTAs | no "comment a word", no follow-for-part-2 |
| 16:9 1920×1080 at 30 fps by default | vertical 1080×1920 only when asked (the engine defaults to 24 — the wrappers pass 30) |
| A structural beat every 2–3 s | cuts, re-layouts, camera moves — not glow or drift |
| Source every claim | primary page, quoted verbatim, URL recorded |
| Report honestly | a check that failed is reported as failed, audio as measured not heard |

## Requirements

| Tool | Version | Why |
|---|---|---|
| Node | ≥ 20 (22 recommended) | the renderer, and `npx bun` for the hook scorer |
| Python | ≥ 3.11 | earshot, subtitles, contact sheets |
| FFmpeg | ≥ 7 | encoding and mastering |
| git | any | fetching the engine |

`./setup.sh` and `./install.sh` are the same script — pick whichever name you expect.
| uv | optional | faster venvs |

What `./setup.sh` downloads on first run, so nobody mistakes it for a bug:

- the **Lemo library** (~150 MB sparse clone: guides, `core/` tools, every `STYLE.md`) into `~/lemo-opuscar`
- **Playwright's Chromium headless shell** for frame capture
- with `--with-sfx`: **earshot** into `vendor/earshot/.venv`, pinned to upstream commit `591fa3e0` (pulls torch — a few GB, several minutes)
- with `--with-voice`: the TTS models for narration

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `BEWARE: your OS is not officially supported by Playwright` | Linux distro without an official build | harmless — it downloads the closest fallback and renders |
| `! packages not installed yet: run 'sh setup.sh deps'` | first run, or the engine's `package.json` changed upstream | `./setup.sh`, or `sh skills/lemo-opuscar/scripts/setup.sh deps` |
| `need bun or npx` | Node < 20 or not installed | install Node 20+, `nvm use 22` |
| earshot "not installed yet" | env not built | `./setup.sh --with-sfx`, or `EARSHOT_BIN=/path/to/earshot` |
| `not_logged_in` / `checkpoint` | Instagram session expired or challenged | `./bin/research.sh login --force`, complete it in the browser |
| `no index.html in …` | pointed at a folder without a page | start from `templates/film` |
| A `✦` style refuses to start | no image generator configured | `python3 core/image/gen_image.py --check`, or pick another style |
| Readcheck fails a line | text is on screen too briefly | a line needs `0.5 s + 0.3 s × words`; cut words or hold longer |

## Verified, not claimed

These numbers come from running the repo, and they are the only performance figures stated here:

- `./setup.sh --check` → **8/8** tool checks pass
- `./bin/render.sh still` → a 1920×1080 frame in **~66–71 ms**
- `./bin/render.sh video` → 60 frames at 30 fps in **3 s**; a 459-frame 15 s reel in **~22 s**
- `./bin/render.sh readcheck` → passes when text is held long enough, and names the line that isn't
- `./bin/render.sh mux` → **−13.9 LUFS**, AAC 48 kHz stereo, 1920×1080 @ 30 fps out
- `./bin/sfx.sh sfx list` → **252 sounds**
- a fresh `git clone` of this repo, then setup + hook + still + readcheck → all pass

Not verified here, and worth knowing: a full film with narration and a mixed soundtrack has not been produced end to end in this repo yet, and an actual Instagram pull needs your own login.

## Credits

Full detail in [`CREDITS.md`](CREDITS.md).

- **[Lemo-Opuscar](https://github.com/lemomo-ai/lemo-opuscar)** — Lemomo. The engine, 100 styles, director and technique guides. `MIT AND CC-BY-NC-4.0`: the styles are **non-commercial**, which this free repo respects. Only the MIT fetcher is bundled; the library is downloaded, never committed.
- **[earshot](https://github.com/Leonxlnx/earshot)** — Leon Lin. SFX bank and sound judgement. MIT.
- **[humanizer](https://github.com/blader/humanizer)** — Siqi Chen. MIT.
- **[instagram-ai-plugin](https://github.com/proyecto26/instagram-ai-plugin)** — Proyecto 26. Research client, 26 hook formulas, caption linter. MIT.
- **[claude-content-skills](https://github.com/Ootto-AI/claude-content-skills)** — Ootto-AI. Creator research and reel teardown. MIT.

## Roadmap

- [ ] a shipped example film, with stills in this README
- [ ] a script-writing skill so stage 2 is a tool, not only judgement
- [ ] caption and Threads variants generated from the film's own script
- [ ] a style previewer: contact sheets for 3 candidate styles before committing

## Contributing

Issues and PRs welcome. If you add a skill, keep its `SKILL.md`, keep its licence notice, add it to `CREDITS.md`, and make sure `./setup.sh --check` still passes on a clean clone. Don't commit media, renders, envs or a copy of the engine library.

<div align="center">

If this saves you a subscription and a weekend, a ⭐ helps someone else find it.

**[⬆ back to top](#any-video-production)**

</div>
