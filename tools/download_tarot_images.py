#!/usr/bin/env python3
"""Download all 78 RWS tarot card images from Wikimedia Commons."""
import json
import os
import subprocess
import time
import urllib.parse
import urllib.request
import ssl

# Card file names from Commons
CARDS = [
    # Major Arcana (22)
    "The Fool (Rider-Waite Smith tarot deck).png",
    "The Magician (Rider-Waite Smith tarot deck).png",
    "The High Priestess (Rider-Waite Smith tarot deck).png",
    "The Empress (Rider-Waite Smith tarot deck).png",
    "The Emperor (Rider-Waite Smith tarot deck).png",
    "The Hierophant (Rider-Waite Smith tarot deck).png",
    "The Lovers (Rider-Waite Smith tarot deck).png",
    "The Chariot (Rider-Waite Smith tarot deck).png",
    "Strength (Rider-Waite Smith tarot deck).png",
    "The Hermit (Rider-Waite Smith tarot deck).png",
    "Wheel of Fortune (Rider-Waite Smith tarot deck).png",
    "Justice (Rider-Waite Smith tarot deck).png",
    "The Hanged Man (Rider-Waite Smith tarot deck).png",
    "Death (Rider-Waite Smith tarot deck).png",
    "Temperance (Rider-Waite Smith tarot deck).png",
    "The Devil (Rider-Waite Smith tarot deck).png",
    "The Tower (Rider-Waite Smith tarot deck).png",
    "The Star (Rider-Waite Smith tarot deck).png",
    "The Moon (Rider-Waite Smith tarot deck).png",
    "The Sun (Rider-Waite Smith tarot deck).png",
    "Judgement (Rider-Waite Smith tarot deck).png",
    "The World (Rider-Waite Smith tarot deck).png",
    # Minor Arcana - Wands (14)
    "Ace of Wands (Rider-Waite Smith tarot deck).png",
    "Two of Wands (Rider-Waite Smith tarot deck).png",
    "Three of Wands (Rider-Waite Smith tarot deck).png",
    "Four of Wands (Rider-Waite Smith tarot deck).png",
    "Five of Wands (Rider-Waite Smith tarot deck).png",
    "Six of Wands (Rider-Waite Smith tarot deck).png",
    "Seven of Wands (Rider-Waite Smith tarot deck).png",
    "Eight of Wands (Rider-Waite Smith tarot deck).png",
    "Nine of Wands (Rider-Waite Smith tarot deck).png",
    "Ten of Wands (Rider-Waite Smith tarot deck).png",
    "Page of Wands (Rider-Waite Smith tarot deck).png",
    "Knight of Wands (Rider-Waite Smith tarot deck).png",
    "Queen of Wands (Rider-Waite Smith tarot deck).png",
    "King of Wands (Rider-Waite Smith tarot deck).png",
    # Minor Arcana - Cups (14)
    "Ace of Cups (Rider-Waite Smith tarot deck).png",
    "Two of Cups (Rider-Waite Smith tarot deck).png",
    "Three of Cups (Rider-Waite Smith tarot deck).png",
    "Four of Cups (Rider-Waite Smith tarot deck).png",
    "Five of Cups (Rider-Waite Smith tarot deck).png",
    "Six of Cups (Rider-Waite Smith tarot deck).png",
    "Seven of Cups (Rider-Waite Smith tarot deck).png",
    "Eight of Cups (Rider-Waite Smith tarot deck).png",
    "Nine of Cups (Rider-Waite Smith tarot deck).png",
    "Ten of Cups (Rider-Waite Smith tarot deck).png",
    "Page of Cups (Rider-Waite Smith tarot deck).png",
    "Knight of Cups (Rider-Waite Smith tarot deck).png",
    "Queen of Cups (Rider-Waite Smith tarot deck).png",
    "King of Cups (Rider-Waite Smith tarot deck).png",
    # Minor Arcana - Swords (14)
    "Ace of Swords (Rider-Waite Smith tarot deck).png",
    "Two of Swords (Rider-Waite Smith tarot deck).png",
    "Three of Swords (Rider-Waite Smith tarot deck).png",
    "Four of Swords (Rider-Waite Smith tarot deck).png",
    "Five of Swords (Rider-Waite Smith tarot deck).png",
    "Six of Swords (Rider-Waite Smith tarot deck).png",
    "Seven of Swords (Rider-Waite Smith tarot deck).png",
    "Eight of Swords (Rider-Waite Smith tarot deck).png",
    "Nine of Swords (Rider-Waite Smith tarot deck).png",
    "Ten of Swords (Rider-Waite Smith tarot deck).png",
    "Page of Swords (Rider-Waite Smith tarot deck).png",
    "Knight of Swords (Rider-Waite Smith tarot deck).png",
    "Queen of Swords (Rider-Waite Smith tarot deck).png",
    "King of Swords (Rider-Waite Smith tarot deck).png",
    # Minor Arcana - Pentacles (14)
    "Ace of Pentacles (Rider-Waite Smith tarot deck).png",
    "Two of Pentacles (Rider-Waite Smith tarot deck).png",
    "Three of Pentacles (Rider-Waite Smith tarot deck).png",
    "Four of Pentacles (Rider-Waite Smith tarot deck).png",
    "Five of Pentacles (Rider-Waite Smith tarot deck).png",
    "Six of Pentacles (Rider-Waite Smith tarot deck).png",
    "Seven of Pentacles (Rider-Waite Smith tarot deck).png",
    "Eight of Pentacles (Rider-Waite Smith tarot deck).png",
    "Nine of Pentacles (Rider-Waite Smith tarot deck).png",
    "Ten of Pentacles (Rider-Waite Smith tarot deck).png",
    "Page of Pentacles (Rider-Waite Smith tarot deck).png",
    "Knight of Pentacles (Rider-Waite Smith tarot deck).png",
    "Queen of Pentacles (Rider-Waite Smith tarot deck).png",
    "King of Pentacles (Rider-Waite Smith tarot deck).png",
]

MAJOR_NAMES = [
    "The Fool", "The Magician", "The High Priestess", "The Empress",
    "The Emperor", "The Hierophant", "The Lovers", "The Chariot",
    "Strength", "The Hermit", "Wheel of Fortune", "Justice",
    "The Hanged Man", "Death", "Temperance", "The Devil",
    "The Tower", "The Star", "The Moon", "The Sun",
    "Judgement", "The World"
]

BASE_DIR = "E:/APP/assets/images/cards"
PROXY = "http://127.0.0.1:7897"
UA = "MysticaTarotBot/1.0"
DELAY = 1.5  # seconds between requests


def get_simple_name(filename):
    name = filename.replace(" (Rider-Waite Smith tarot deck)", "").replace(" ", "_")
    return name.replace(".png", "")


def get_download_url(commons_filename):
    ssl_ctx = ssl.create_default_context()
    ssl_ctx.check_hostname = False
    ssl_ctx.verify_mode = ssl.CERT_NONE
    
    title = "File:" + commons_filename
    api = f"https://commons.wikimedia.org/w/api.php?action=query&titles={urllib.parse.quote(title)}&prop=imageinfo&iiprop=url&format=json"
    
    req = urllib.request.Request(api, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, context=ssl_ctx, timeout=15) as resp:
        data = json.loads(resp.read())
        for pid, info in data.get("query", {}).get("pages", {}).items():
            if pid != "-1":
                return info["imageinfo"][0]["url"]
    return None


def main():
    os.makedirs(f"{BASE_DIR}/major", exist_ok=True)
    os.makedirs(f"{BASE_DIR}/minor", exist_ok=True)
    
    # Remove placeholder files
    for d in ["major", "minor"]:
        p = f"{BASE_DIR}/{d}/placeholder.png"
        if os.path.exists(p):
            os.remove(p)
    
    total = len(CARDS)
    success = 0
    skipped = 0
    failed = 0
    
    for i, filename in enumerate(CARDS, 1):
        simple = get_simple_name(filename)
        is_major = any(name in filename for name in MAJOR_NAMES)
        subdir = "major" if is_major else "minor"
        save_path = f"{BASE_DIR}/{subdir}/{simple}.png"
        
        if os.path.exists(save_path) and os.path.getsize(save_path) > 1000:
            print(f"[{i}/{total}] SKIP: {simple} (already exists)")
            skipped += 1
            continue
        
        try:
            url = get_download_url(filename)
            if not url:
                print(f"[{i}/{total}] ERR: {simple} (URL not found)")
                failed += 1
                continue
            
            cmd = f'curl -x {PROXY} --ssl-no-revoke -s -o "{save_path}" "{url}"'
            r = subprocess.run(cmd, shell=True, capture_output=True, timeout=30)
            
            if r.returncode == 0 and os.path.exists(save_path) and os.path.getsize(save_path) > 1000:
                print(f"[{i}/{total}] OK: {simple}")
                success += 1
            else:
                print(f"[{i}/{total}] FAIL: {simple}")
                failed += 1
        except Exception as e:
            print(f"[{i}/{total}] ERR: {simple} - {e}")
            failed += 1
        
        time.sleep(DELAY)
    
    print(f"\n=== Summary ===")
    print(f"Total: {total}")
    print(f"Downloaded: {success}")
    print(f"Skipped: {skipped}")
    print(f"Failed: {failed}")


if __name__ == "__main__":
    main()
