"""Synth five cues with numpy + librosa only — the 'can librosa replace earshot?' test.

librosa ships no samples and no sound bank. What it offers is analysis (onset, beat, feature)
and effects (hpss, pitch_shift, time_stretch, preemphasis, trim). So every sound here is built
from two raw sources — white noise and sine tones — then shaped by those effects. Nothing is
borrowed from earshot's 252-sound bank.

Run with the earshot env (it already depends on librosa):
    ../earshot/.venv/bin/python make-librosa-sfx.py
"""
import numpy as np, librosa, soundfile as sf, pathlib

SR = 48000
rng = np.random.default_rng(7)          # seeded: the test is repeatable
OUT = pathlib.Path(__file__).parent / "sfx" / "librosa"
OUT.mkdir(parents=True, exist_ok=True)


def peak_norm(y, db=-6.0):
    m = np.max(np.abs(y)) or 1.0
    return y / m * (10 ** (db / 20))


def dur(y):
    return len(y) / SR


def write(name, y):
    y = peak_norm(y.astype(np.float32))
    sf.write(OUT / f"{name}.wav", y, SR, subtype="PCM_16")
    print(f"{name:14s} {dur(y):.3f}s  peak {20*np.log10(np.max(np.abs(y))):.1f} dBFS")


def noise(n):
    return rng.normal(0, 1, n).astype(np.float32)


# 1 · impact — noise burst, harmonic/percussive split, pitched down
n = int(0.30 * SR)
y = noise(n) * np.exp(-np.linspace(0, 9, n))
_, perc = librosa.effects.hpss(y)
y = librosa.effects.pitch_shift(perc, sr=SR, n_steps=-5)
write("01-impact", y)

# 2 · whoosh — noise with a rising then falling envelope, stretched
n = int(0.45 * SR)
y = noise(n) * np.sin(np.linspace(0, np.pi, n)) ** 1.6
y = librosa.effects.preemphasis(y)
y = librosa.effects.time_stretch(y, rate=0.9)
write("02-whoosh", y)

# 3 · sub drop — sine sweep 110 → 38 Hz
n = int(0.55 * SR)
f = np.linspace(110, 38, n)
y = np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-np.linspace(0, 4, n))
write("03-sub", y)

# 4 · tick — two-sample impulse, trimmed and pitched up
y = np.zeros(int(0.06 * SR), dtype=np.float32)
y[40] = 1.0
y = librosa.effects.pitch_shift(y, sr=SR, n_steps=12)
_, y = librosa.effects.hpss(y)
write("04-tick", y)

# 5 · air — noise, percussive split, long tail
n = int(0.70 * SR)
y = noise(n) * np.exp(-np.linspace(0, 2.2, n))
_, y = librosa.effects.hpss(y)
y = librosa.effects.pitch_shift(y, sr=SR, n_steps=3)
write("05-air", y)

print(f"\n5 cues written to {OUT}")
print("sources used: white noise, sine sweep — no sample library, no bank")
