# Styles

The engine's own library is the default: **100 styles**, each a `STYLE.md` (fixed invariants) plus a
demo film made in code. After `./setup.sh` they are at `$HOME/lemo-opuscar/styles/`, indexed in
`styles/README.md` there.

Pick by name in English or Chinese, or by folder slug:

```bash
ls ~/lemo-opuscar/styles | head -40
sed -n '1,60p' ~/lemo-opuscar/styles/README.md
```

## Choosing

- Offer 2–3 styles that fit the topic, never the whole list as a wall of text.
- A style marked `✦` draws with an image generator and needs one configured; without it the film
  cannot start. Say so before the brief, not after.
- Read the chosen `STYLE.md` fully: look, colour, type, motion, camera grammar, sound palette,
  native moves, pitfalls. Keep all of it; direct everything else yourself.

## External style libraries (optional, not bundled)

Clone only if a client asks for something outside Lemo's grammar:

```bash
git clone https://github.com/Vincentwei1021/mg-styles-15            # 15 MG styles, source + films
git clone https://github.com/HiAPIAI/awesome-opus-5-5-video-styles  # 12 style notes
git clone https://github.com/yasinozmeen/animasyon-stil-katalogu    # style catalog
git clone https://github.com/alchaincyf/huashu-art-motion           # motion engine + examples
```

They are references for look and technique. The house rules in `AGENTS.md` still win: Minecraft
type, no music, no faces, Clawd in the performance, 30 fps, no CTA.
