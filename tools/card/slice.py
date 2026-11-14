"""Slice the four 5×5 sheets into one preview JPEG per style."""
import json, subprocess, pathlib
root = pathlib.Path(__file__).resolve().parents[2]
cards = json.load(open(root / "tools/card/cards.json"))["cards"]
for k, c in enumerate(cards):
    sheet, idx = k // 25, k % 25
    col, row = idx % 5, idx // 5
    src = root / f"tools/card/sheets/sheet{sheet}0.1.jpg"
    out = root / f"styles/previews/{c['slug']}.jpg"
    subprocess.run(["ffmpeg", "-y", "-v", "error", "-i", str(src),
                    "-vf", f"crop=768:432:{col*768}:{row*432},scale=480:270:flags=lanczos",
                    "-q:v", "5", str(out)], check=True)
print(f"{len(cards)} tiles")
