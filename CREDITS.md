# Third-party work in this repo

Bundled files keep their upstream licence. Nothing here is relicensed by this repo.

| Component | Where | Licence | Author / source |
|---|---|---|---|
| earshot | `skills/earshot/` (installed on demand) | MIT | Leon Lin — `github.com/Leonxlnx/earshot` |
| humanizer | `skills/humanizer/` | MIT | Siqi Chen — `blader/humanizer` 4.0.0 |
| instagram-research, instagram client | `skills/instagram-research/`, `skills/instagram/` | MIT | Proyecto 26 — `proyecto26/instagram-ai-plugin` |
| hook formulas + scorer | `skills/instagram-content/scripts/` | MIT | same repo |
| content-research, reel-analyzer | `skills/content-research/`, `skills/reel-analyzer/` | MIT | Ootto-AI — `Ootto-AI/claude-content-skills` |
| lemo-opuscar skill (fetcher) | `skills/lemo-opuscar/` | MIT AND CC-BY-NC-4.0 | Lemomo — `lemomo-ai/lemo-opuscar` |
| Lemo-Opuscar library (fetched, not committed) | `~/lemo-opuscar` | MIT AND CC-BY-NC-4.0 | Lemomo |

## Publishing this repo

This repo is free, public and non-commercial, and every bundled component allows that:

1. **Lemo-Opuscar is `MIT AND CC-BY-NC-4.0`.** The NC part covers the style prompts and demo films.
   This repo ships only the MIT plugin fetcher, not the library, and is itself non-commercial — so
   bundling it is within the terms. A fork that *sells* films made in a style is a different case;
   that is the fork's call, not this repo's.
2. **Two things were deliberately left out** of this bundle because they carry no licence:
   - `hookscore.py` + `hooks.json` from the "reel skill" packs — replaced by the MIT TypeScript
     scorer in `skills/instagram-content/scripts/`.
   - The HyperFrames skill docs — HyperFrames is used only as an optional external fallback
     (`npx hyperframes`), never bundled.
3. **Your own films** are yours; the mascot, fonts and marker recording you supply are your assets.
