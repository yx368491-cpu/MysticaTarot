#!/usr/bin/env python3
"""Generate procedurally synthesized sound effects for MysticaTarot.

Produces four 22050 Hz, 16-bit, mono WAV files in assets/sounds/:
  - shuffle.wav  (0.8s)  rhythmic noise bursts simulating card-shuffling
  - flip.wav     (0.25s) crisp paper-snap transient
  - fan.wav      (0.4s)  arched noise "swoosh"
  - reveal.wav   (1.5s)  C-major chord ding (C5 + E5 + G5) with slow decay

Pure stdlib (math / random / struct / wave / os). No numpy needed.
Deterministic given the seed below (set explicitly so re-runs produce the
exact same bytes — important for git diffs).

Usage:
    python tools/generate_sounds.py
"""

import math
import os
import random
import struct
import wave

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOUNDS_DIR = os.path.join(BASE_DIR, "assets", "sounds")
SAMPLE_RATE = 22050

# Fixed seed so regeneration is byte-stable across machines / dev boxes.
# Seed is module-level so 'from tools.generate_sounds import generate_X' is
# also deterministic even if `main()` is never called.
_SEED = 20260623
random.seed(_SEED)


def _ensure_dir(path):
    os.makedirs(path, exist_ok=True)


def _write_wav(filename, samples):
    """Write a list of float samples [-1.0, 1.0] to a 16-bit mono WAV file."""
    filepath = os.path.join(SOUNDS_DIR, filename)
    data = bytearray()
    for s in samples:
        clipped = max(-1.0, min(1.0, s))
        # 16-bit signed little-endian PCM
        data.extend(struct.pack('<h', int(clipped * 32767)))
    with wave.open(filepath, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SAMPLE_RATE)
        w.writeframes(bytes(data))
    duration_sec = len(samples) / SAMPLE_RATE
    print(f"  {filename:14s} {duration_sec:5.2f}s  {os.path.getsize(filepath):>7d} bytes")


def generate_shuffle():
    """0.8s rhythmic noise bursts — like cards rubbing together."""
    samples = []
    length = int(SAMPLE_RATE * 0.8)
    for i in range(length):
        t = i / SAMPLE_RATE
        noise = random.uniform(-1.0, 1.0)
        # Burst envelope: sin² with period ==> ~6 lobes over 0.8s
        burst_env = math.sin(t * math.pi * 8.0) ** 2
        # Overall fade so the burst doesn't pop on stop
        fade_env = math.exp(-t * 2.0)
        samples.append(noise * burst_env * fade_env * 0.40)
    return samples


def generate_flip():
    """0.25s crisp paper-snap with very fast exponential decay."""
    samples = []
    length = int(SAMPLE_RATE * 0.25)
    for i in range(length):
        t = i / SAMPLE_RATE
        noise = random.uniform(-1.0, 1.0)
        # Fast decay (e^-30t) gives a sharp attack → silent in ~0.15s
        env = math.exp(-t * 30.0)
        samples.append(noise * env * 0.50)
    return samples


def generate_fan():
    """0.4s swoosh — arched (sin²) noise envelope."""
    samples = []
    length = int(SAMPLE_RATE * 0.4)
    for i in range(length):
        t = i / SAMPLE_RATE
        progress = t / 0.4  # 0.0 → 1.0
        noise = random.uniform(-1.0, 1.0)
        env = math.sin(progress * math.pi) ** 2   # smooth 0 → 1 → 0
        samples.append(noise * env * 0.30)
    return samples


def generate_reveal():
    """1.5s C-major chord ding (C5 + E5 + G5) with slow exponential decay."""
    samples = []
    length = int(SAMPLE_RATE * 1.5)
    # Frequencies for C5, E5, G5
    freqs = (523.25, 659.25, 783.99)
    # Soft 30 ms attack so the ding isn't a click
    attack = int(SAMPLE_RATE * 0.030)
    for i in range(length):
        t = i / SAMPLE_RATE
        # Attack-decay envelope
        if i < attack:
            env = i / attack
        else:
            env = math.exp(-(t - 0.030) * 2.5)
        chord = sum(math.sin(2.0 * math.pi * f * t) for f in freqs) / 3.0
        samples.append(chord * env * 0.45)
    return samples


def main():
    _ensure_dir(SOUNDS_DIR)
    print(f"Output dir: {SOUNDS_DIR}")
    print(f"Sample rate: {SAMPLE_RATE} Hz, 16-bit mono, seed={_SEED}")
    print("Generating:")
    _write_wav("shuffle.wav", generate_shuffle())
    _write_wav("flip.wav", generate_flip())
    _write_wav("fan.wav", generate_fan())
    _write_wav("reveal.wav", generate_reveal())
    # Self-verify output file sizes — catches edits to duration constants
    # that would silently produce wrong-sized assets.
    expected = {
        "shuffle.wav": 35_324,  # 0.8s × 22050 Hz × 2 bytes + 44 header
        "flip.wav":    11_068,  # 0.25s
        "fan.wav":     17_684,  # 0.4s
        "reveal.wav":  66_194,  # 1.5s
    }
    for name, want in expected.items():
        got = os.path.getsize(os.path.join(SOUNDS_DIR, name))
        assert got == want, f"{name}: expected {want} bytes, got {got}"
    print("All files match expected byte sizes. Done.")


if __name__ == "__main__":
    main()
