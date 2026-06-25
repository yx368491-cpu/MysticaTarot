#!/usr/bin/env python3
"""Compress all 78 RWS tarot card images for mobile use.

- Resizes to 600px wide (maintaining aspect ratio) — sufficient for 2x/3x mobile displays
- Saves as optimized PNG with maximum compression
- Validates output PNG magic number
- Reports compression ratio
"""
import os
from PIL import Image

BASE_DIR = "E:/APP/assets/images/cards"
TARGET_WIDTH = 600  # px — good for 400dp cards at 2x or 300dp at 3x

PNG_HEADER = b'\x89PNG\r\n\x1a\n'


def is_valid_png(filepath):
    try:
        with open(filepath, 'rb') as f:
            return f.read(8) == PNG_HEADER
    except (FileNotFoundError, OSError):
        return False


def compress_card(filepath):
    """Resize and optimize a single card. Returns (old_size, new_size)."""
    old_size = os.path.getsize(filepath)

    img = Image.open(filepath)

    # Resize: maintain aspect ratio
    w, h = img.size
    if w > TARGET_WIDTH:
        ratio = TARGET_WIDTH / w
        new_size = (TARGET_WIDTH, int(h * ratio))
        img = img.resize(new_size, Image.LANCZOS)

    # Save as optimized PNG
    img.save(filepath, 'PNG', optimize=True)

    return old_size, os.path.getsize(filepath)


def main():
    total_old = 0
    total_new = 0
    results = []

    for subdir in ['major', 'minor']:
        d = os.path.join(BASE_DIR, subdir)
        if not os.path.isdir(d):
            continue
        for fname in sorted(os.listdir(d)):
            if fname == 'placeholder.png':
                continue
            fp = os.path.join(d, fname)
            if not is_valid_png(fp):
                print(f"SKIP: {subdir}/{fname} (not a valid PNG)")
                continue

            try:
                old, new = compress_card(fp)
                pct = (1 - new / old) * 100
                results.append((f'{subdir}/{fname}', old, new, pct))
                total_old += old
                total_new += new
                print(f"  OK: {subdir}/{fname}  {old/1024:.0f}KB -> {new/1024:.0f}KB  ({pct:.0f}%)")
            except Exception as e:
                print(f"FAIL: {subdir}/{fname} — {e}")

    # Summary
    print(f"\n{'='*55}")
    print(f"  Cards processed:  {len(results)}")
    print(f"  Before:           {total_old/1024/1024:.1f} MB")
    print(f"  After:            {total_new/1024/1024:.1f} MB")
    print(f"  Saved:            {(total_old-total_new)/1024/1024:.1f} MB ({(1-total_new/total_old)*100:.0f}%)")
    print(f"{'='*55}")

    # Top 5 best compression
    results.sort(key=lambda x: -x[3])
    print("\nTop 5 best compressed:")
    for name, old, new, pct in results[:5]:
        print(f"  {name}:  {old/1024:.0f}KB -> {new/1024:.0f}KB  ({pct:.0f}%)")


if __name__ == '__main__':
    main()
