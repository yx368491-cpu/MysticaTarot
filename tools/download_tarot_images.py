#!/usr/bin/env python3
"""Download all 78 RWS tarot card images from Wikimedia Commons.

Improvements over v1:
- Validates PNG magic number (\\x89PNG) — rejects HTML error pages
- Uses Wikimedia thumbnail URLs (800px) to avoid 429 rate-limit
- Auto-deletes fake/corrupt PNG files before re-downloading
- Longer delay between requests (3s) for politeness
- Graceful proxy check before starting
"""
import json
import os
import subprocess
import time
import urllib.parse
import urllib.request
import ssl

try:
    from PIL import Image
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

# Card file names from Commons
# Two cards use a different filename on Commons (RWS1909 JPEGs).
# We keep the standard names in CARDS and map them in FALLBACK_CARDS.
_CARD_SIMPLE_NAMES = [
    # Major Arcana (22)
    "The_Fool", "The_Magician", "The_High_Priestess", "The_Empress",
    "The_Emperor", "The_Hierophant", "The_Lovers", "The_Chariot",
    "Strength", "The_Hermit", "Wheel_of_Fortune", "Justice",
    "The_Hanged_Man", "Death", "Temperance", "The_Devil",
    "The_Tower", "The_Star", "The_Moon", "The_Sun",
    "Judgement", "The_World",
    # Minor Arcana - Wands (14)
    "Ace_of_Wands", "Two_of_Wands", "Three_of_Wands", "Four_of_Wands",
    "Five_of_Wands", "Six_of_Wands", "Seven_of_Wands", "Eight_of_Wands",
    "Nine_of_Wands", "Ten_of_Wands", "Page_of_Wands", "Knight_of_Wands",
    "Queen_of_Wands", "King_of_Wands",
    # Minor Arcana - Cups (14)
    "Ace_of_Cups", "Two_of_Cups", "Three_of_Cups", "Four_of_Cups",
    "Five_of_Cups", "Six_of_Cups", "Seven_of_Cups", "Eight_of_Cups",
    "Nine_of_Cups", "Ten_of_Cups", "Page_of_Cups", "Knight_of_Cups",
    "Queen_of_Cups", "King_of_Cups",
    # Minor Arcana - Swords (14)
    "Ace_of_Swords", "Two_of_Swords", "Three_of_Swords", "Four_of_Swords",
    "Five_of_Swords", "Six_of_Swords", "Seven_of_Swords", "Eight_of_Swords",
    "Nine_of_Swords", "Ten_of_Swords", "Page_of_Swords", "Knight_of_Swords",
    "Queen_of_Swords", "King_of_Swords",
    # Minor Arcana - Pentacles (14)
    "Ace_of_Pentacles", "Two_of_Pentacles", "Three_of_Pentacles", "Four_of_Pentacles",
    "Five_of_Pentacles", "Six_of_Pentacles", "Seven_of_Pentacles", "Eight_of_Pentacles",
    "Nine_of_Pentacles", "Ten_of_Pentacles", "Page_of_Pentacles", "Knight_of_Pentacles",
    "Queen_of_Pentacles", "King_of_Pentacles",
]


def _get_commons_filename(simple_name):
    """Return the actual Wikimedia Commons filename for a card.

    Most cards follow the 'X of Y (Rider-Waite Smith tarot deck).png' pattern.
    Exceptions are listed in FALLBACK_CARDS."""
    if simple_name in FALLBACK_CARDS:
        return FALLBACK_CARDS[simple_name]
    # Convert simple_name back to Commons filename pattern
    # e.g. 'Ace_of_Wands' -> 'Ace of Wands (Rider-Waite Smith tarot deck).png'
    readable = simple_name.replace('_', ' ')
    return f"{readable} (Rider-Waite Smith tarot deck).png"

MAJOR_NAMES = [
    "The Fool", "The Magician", "The High Priestess", "The Empress",
    "The Emperor", "The Hierophant", "The Lovers", "The Chariot",
    "Strength", "The Hermit", "Wheel of Fortune", "Justice",
    "The Hanged Man", "Death", "Temperance", "The Devil",
    "The Tower", "The Star", "The Moon", "The Sun",
    "Judgement", "The World"
]

# Cards whose Wikimedia Commons filename differs from the standard
# "X of Y (Rider-Waite Smith tarot deck).png" pattern.
# Maps simple_name -> actual Commons filename
FALLBACK_CARDS = {
    "Ace_of_Swords": "RWS1909 - Swords 01.jpeg",
    "Ace_of_Pentacles": "RWS1909 - Pentacles 01.jpeg",
}

BASE_DIR = "E:/APP/assets/images/cards"
PROXY = "http://127.0.0.1:7897"
UA = "MysticaTarotBot/2.0 (thumbnail downloader; max 1 req/3s)"
# Use 800px thumbnails per Wikimedia recommendation for rate-limited clients.
# Full-size images are ~13 MB; 800px thumbs are ~100-300 KB — plenty for mobile.
THUMB_WIDTH = 800
DELAY = 3.0  # seconds between requests


def is_valid_png(filepath):
    """Return True if the file starts with the PNG magic number."""
    try:
        with open(filepath, 'rb') as f:
            return f.read(8) == b'\x89PNG\r\n\x1a\n'
    except (FileNotFoundError, OSError):
        return False


def get_thumbnail_url(commons_filename):
    """Query Wikimedia API for a thumbnail URL of the given file."""
    ssl_ctx = ssl.create_default_context()
    ssl_ctx.check_hostname = False
    ssl_ctx.verify_mode = ssl.CERT_NONE

    title = "File:" + commons_filename
    api = (
        "https://commons.wikimedia.org/w/api.php"
        "?action=query"
        f"&titles={urllib.parse.quote(title)}"
        "&prop=imageinfo"
        "&iiprop=url"
        f"&iiurlwidth={THUMB_WIDTH}"
        "&format=json"
    )

    req = urllib.request.Request(api, headers={"User-Agent": UA})
    try:
        with urllib.request.urlopen(req, context=ssl_ctx, timeout=15) as resp:
            data = json.loads(resp.read())
            for pid, info in data.get("query", {}).get("pages", {}).items():
                if pid != "-1":
                    ii = info.get("imageinfo", [{}])[0]
                    # Prefer thumbnail URL; fall back to full-size
                    return ii.get("thumburl") or ii.get("url")
    except Exception as e:
        print(f"    API error: {e}")
    return None


def cleanup_fake_pngs(base_dir):
    """Delete all files in major/ and minor/ that are not valid PNGs."""
    deleted = 0
    for subdir in ["major", "minor"]:
        d = os.path.join(base_dir, subdir)
        if not os.path.isdir(d):
            continue
        for fname in os.listdir(d):
            if fname == "placeholder.png":
                continue
            fp = os.path.join(d, fname)
            if os.path.isfile(fp) and not is_valid_png(fp):
                os.remove(fp)
                print(f"  CLEANED: {subdir}/{fname}")
                deleted += 1
    if deleted:
        print(f"  -> Deleted {deleted} fake/corrupt file(s)\n")


def download_file(url, save_path):
    """Download via curl through proxy. Converts JPEG to PNG if needed.

    Returns True on success (valid PNG saved at save_path)."""
    cmd = (
        f'curl -x {PROXY} --ssl-no-revoke -s -L'
        f' -o "{save_path}"'
        f' --connect-timeout 15 --max-time 60'
        f' "{url}"'
    )
    r = subprocess.run(cmd, shell=True, capture_output=True, timeout=90)
    if r.returncode != 0:
        return False
    if not os.path.exists(save_path):
        return False

    # Already a valid PNG?
    if is_valid_png(save_path):
        return True

    # Try JPEG → PNG conversion (for RWS1909 fallback cards)
    if HAS_PIL:
        try:
            img = Image.open(save_path)
            img.save(save_path, 'PNG')
            if is_valid_png(save_path):
                return True
        except Exception:
            pass

    # Not a usable image — discard
    if os.path.exists(save_path):
        os.remove(save_path)
    return False


def check_proxy():
    """Quick check that the proxy is reachable."""
    try:
        r = subprocess.run(
            f'curl -x {PROXY} --connect-timeout 5 -s -o NUL -w "%{{http_code}}" https://commons.wikimedia.org',
            shell=True, capture_output=True, timeout=10,
        )
        code = r.stdout.decode().strip()
        if code in ("200", "301", "302"):
            return True
        print(f"WARNING: Proxy returned HTTP {code} for Wikimedia")
        return False
    except Exception as e:
        print(f"WARNING: Proxy check failed: {e}")
        return False


def main():
    os.makedirs(f"{BASE_DIR}/major", exist_ok=True)
    os.makedirs(f"{BASE_DIR}/minor", exist_ok=True)

    # --- Step 1: Cleanup ---
    print("=== Step 1: Cleaning up fake/corrupt PNGs ===")
    cleanup_fake_pngs(BASE_DIR)

    # --- Step 2: Proxy check ---
    print("=== Step 2: Proxy check ===")
    if not check_proxy():
        print("Proxy may be offline. Continuing anyway...")
    else:
        print("  Proxy OK\n")

    # --- Step 3: Download ---
    total = len(_CARD_SIMPLE_NAMES)
    success = 0
    skipped = 0
    failed = 0

    print(f"=== Step 3: Downloading {total} images ({THUMB_WIDTH}px thumbs, {DELAY}s delay) ===\n")

    for i, simple_name in enumerate(_CARD_SIMPLE_NAMES, 1):
        commons_name = _get_commons_filename(simple_name)
        is_major = any(name.replace(' ', '_') == simple_name for name in MAJOR_NAMES)
        subdir = "major" if is_major else "minor"
        save_path = f"{BASE_DIR}/{subdir}/{simple_name}.png"

        # Skip if already valid
        if os.path.exists(save_path) and is_valid_png(save_path):
            sz_kb = os.path.getsize(save_path) / 1024
            print(f"[{i:3d}/{total}] SKIP: {simple_name} ({sz_kb:.0f} KB)")
            skipped += 1
            continue

        try:
            url = get_thumbnail_url(commons_name)
            if not url:
                print(f"[{i:3d}/{total}] FAIL: {simple_name} (no URL)")
                failed += 1
                continue

            if download_file(url, save_path):
                sz_kb = os.path.getsize(save_path) / 1024
                print(f"[{i:3d}/{total}]  OK : {simple_name} ({sz_kb:.0f} KB)")
                success += 1
            else:
                print(f"[{i:3d}/{total}] FAIL: {simple_name} (download/validation failed)")
                failed += 1
        except Exception as e:
            print(f"[{i:3d}/{total}] ERR : {simple_name} — {e}")
            failed += 1

        time.sleep(DELAY)

    # --- Summary ---
    print(f"\n{'='*50}")
    print(f"  Total:      {total}")
    print(f"  Downloaded: {success}")
    print(f"  Skipped:    {skipped}")
    print(f"  Failed:     {failed}")
    print(f"{'='*50}")

    if failed == 0:
        print("All images downloaded successfully!")
    else:
        print(f"{failed} image(s) failed. Re-run the script to retry.")


if __name__ == "__main__":
    main()
