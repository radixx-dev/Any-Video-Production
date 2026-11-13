# Rules for agents working in this repo

Read `skills/pipeline/SKILL.md` for the order of work and `docs/chain.md` for commands.
These rules win over any style guide the pipeline loads.

## Order of work

Boards and timing first, typography and grid second, motion third, sound last, then measure.
Never animate before the composition is decided.

## Craft

1. **One idea per screen.** ≤ 5 words per line, never two stacked blocks. A line needs
   `0.5 s + 0.3 s × words` on screen; a closing line needs 2 s.
2. **Change the picture every 2–3 s.** Count only structural beats — a cut, a group entering or
   re-laying out, a camera or grid move, a strong light shift. Glow pulses and slow drifts are not
   beats. Plan ~2.5 s per beat in the board stage.
3. **Every keyframe on a frame boundary**, one easing family per film, animate groups not loose
   elements.
4. **Formation over accumulation**: aligned columns, equal gaps, matched radii, whole groups moving.
5. **Sound is measured, never assumed.** Effect peaks within ~8 dB of the voice peak, peak one
   frame after the picture move. Report the loudness number you measured; say audio was measured,
   not heard.

## House rules for every film

- **Minecraft font** for all on-screen lettering, whatever the style's spec names.
- **No music.** Voice plus foley only.
- **No faces, no human figures.** People become objects, silhouettes or the mascot.
- **Clawd belongs in the performance**, drawn from the canonical asset, never redrawn or recoloured.
- **No engagement-bait CTAs**: no "comment a word", no follow-for-part-2.
- **16:9 1920×1080 at 30 fps** by default (Lemo defaults to 24 — pass `--fps 30`); vertical
  1080×1920 only when the client asks.
- **No engine sign-off** in the picture or the copy: `grep -rniE "lemo ?lab|opus 5\.5"` on the film
  folder must come back empty outside `LICENSE`, `CREDITS` and `LIB=` lines.

## Sourcing

- Every factual line, hadith, ayah, study or number is checked on the primary page, quoted
  verbatim, and recorded with its URL. Unsupported lines go to the client, not into the film.
- Adapt structure from research, never words, captions or footage.
- `CREDITS` in each film lists every third-party asset and its licence.

## Reporting

Say what was checked and what was not. A check that failed or could not run is reported as such,
never as a pass. Renders and measurements are facts; taste is the client's.
