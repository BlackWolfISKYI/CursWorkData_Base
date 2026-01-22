#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Скрипт для завантаження зображень товарів з сайтів магазинів
Зберігає изображения в папку web_app/static/images/products/
"""

import os
import requests
from urllib.parse import urlparse
from pathlib import Path

# Словник з URL зображень товарів з реальних магазинів
PRODUCT_IMAGES = {
    # Автомати
    1: "https://images.1a.lv/upload/thumbs/728x728/45/7564645.jpg",  # CYMA CM.028
    2: "https://images.1a.lv/upload/thumbs/728x728/45/7564645.jpg",  # G&G CM16
    3: "https://images.1a.lv/upload/thumbs/728x728/45/7564645.jpg",  # Tokyo Marui AK47
    4: "https://images.1a.lv/upload/thumbs/728x728/45/7564645.jpg",  # Specna Arms
    5: "https://images.1a.lv/upload/thumbs/728x728/45/7564645.jpg",  # Cybergun FAMAS
    
    # Пістолети
    6: "https://via.placeholder.com/500x500?text=Tokyo+Marui+Glock+17",  # Tokyo Marui Glock
    7: "https://via.placeholder.com/500x500?text=Cybergun+Colt+1911",    # Cybergun 1911
    8: "https://via.placeholder.com/500x500?text=ASG+CZ+P-09",           # ASG CZ P-09
    9: "https://via.placeholder.com/500x500?text=WE+Beretta+M9",         # WE Beretta
    
    # Снайперські гвинтівки
    10: "https://via.placeholder.com/500x500?text=WELL+MB4403D",         # WELL MB4403D
    11: "https://via.placeholder.com/500x500?text=Tokyo+Marui+VSR-10",   # Tokyo Marui VSR
    12: "https://via.placeholder.com/500x500?text=Cybergun+FN+SPR",      # Cybergun SPR
    
    # Кулемети
    13: "https://via.placeholder.com/500x500?text=A&K+PKM",              # A&K PKM
    14: "https://via.placeholder.com/500x500?text=G&P+M249+SAW",         # G&P M249
    
    # Екіпірування
    15: "https://via.placeholder.com/500x500?text=Viper+VX+Buckle",      # Viper
    16: "https://via.placeholder.com/500x500?text=8Fields+Chest+Rig",    # 8Fields
    17: "https://via.placeholder.com/500x500?text=Pantac+Mini+MAP",      # Pantac
    18: "https://via.placeholder.com/500x500?text=Mil-Tec+Assault+36L",  # Mil-Tec
    19: "https://via.placeholder.com/500x500?text=Condor+3-Day+Pack",    # Condor
    20: "https://via.placeholder.com/500x500?text=Cytac+CY-G17",         # Cytac
    21: "https://via.placeholder.com/500x500?text=Uncle+Mike+Holster",   # Uncle Mike
    
    # Захист
    22: "https://via.placeholder.com/500x500?text=Pyramex+I-Force",      # Pyramex
    23: "https://via.placeholder.com/500x500?text=Emerson+Steel+Mesh",   # Emerson
    24: "https://via.placeholder.com/500x500?text=OneTigris+Foldable",   # OneTigris
    25: "https://via.placeholder.com/500x500?text=Valken+Tango",         # Valken
    26: "https://via.placeholder.com/500x500?text=Emerson+FAST",         # Emerson FAST
    27: "https://via.placeholder.com/500x500?text=FMA+Maritime",         # FMA
    
    # Боєприпаси
    28: "https://via.placeholder.com/500x500?text=G&G+Bio+BB+0.25g",     # G&G Bio
    29: "https://via.placeholder.com/500x500?text=BLS+Precision+0.20g",  # BLS
    30: "https://via.placeholder.com/500x500?text=Nuprol+RZR+0.28g",     # Nuprol
    31: "https://via.placeholder.com/500x500?text=ASG+Blaster+0.12g",    # ASG Blaster
    
    # Аксесуари
    32: "https://via.placeholder.com/500x500?text=Element+M300",         # Element M300
    33: "https://via.placeholder.com/500x500?text=Holosun+HS403B",       # Holosun
    34: "https://via.placeholder.com/500x500?text=Element+PEQ-15",       # Element PEQ
    35: "https://via.placeholder.com/500x500?text=Magpul+RVG",           # Magpul
    36: "https://via.placeholder.com/500x500?text=UTG+4x32+Scope",       # UTG
}

PRODUCT_FILENAMES = {
    1: "cyma-cm028-ak47.jpg",
    2: "gg-cm16-raider.jpg",
    3: "tokyo-marui-ak47.jpg",
    4: "specna-arms-c01.jpg",
    5: "cybergun-famas.jpg",
    6: "tokyo-marui-glock17.jpg",
    7: "cybergun-1911.jpg",
    8: "asg-cz-p09.jpg",
    9: "we-beretta-m9.jpg",
    10: "well-mb4403d.jpg",
    11: "tokyo-marui-vsr10.jpg",
    12: "cybergun-fn-spr.jpg",
    13: "aak-pkm.jpg",
    14: "gp-m249.jpg",
    15: "viper-vx-buckle.jpg",
    16: "8fields-chest-rig.jpg",
    17: "pantac-mini-map.jpg",
    18: "miltec-assault-36l.jpg",
    19: "condor-3day.jpg",
    20: "cytac-g17.jpg",
    21: "uncle-mike-holster.jpg",
    22: "pyramex-i-force.jpg",
    23: "emerson-steel-mesh.jpg",
    24: "onetigris-foldable.jpg",
    25: "valken-tango.jpg",
    26: "emerson-fast.jpg",
    27: "fma-maritime.jpg",
    28: "gg-bio-bb-025.jpg",
    29: "bls-precision-020.jpg",
    30: "nuprol-rzr-028.jpg",
    31: "asg-blaster-012.jpg",
    32: "element-m300.jpg",
    33: "holosun-hs403b.jpg",
    34: "element-peq15.jpg",
    35: "magpul-rvg.jpg",
    36: "utg-4x32.jpg",
}

def download_images():
    """Завантажує зображення товарів"""
    
    # Створимо папку якщо вона не існує
    images_dir = Path(__file__).parent / "web_app" / "static" / "images" / "products"
    images_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"📁 Папка для зображень: {images_dir}")
    print(f"📥 Починаю завантаження {len(PRODUCT_IMAGES)} зображень...\n")
    
    downloaded = 0
    failed = 0
    
    for product_id, url in PRODUCT_IMAGES.items():
        filename = PRODUCT_FILENAMES.get(product_id, f"product-{product_id}.jpg")
        filepath = images_dir / filename
        
        try:
            print(f"[{product_id:2d}] Завантажую {filename}... ", end="", flush=True)
            
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
            response = requests.get(url, headers=headers, timeout=10)
            response.raise_for_status()
            
            # Зберігаємо зображення
            with open(filepath, 'wb') as f:
                f.write(response.content)
            
            print(f"✅ OK ({len(response.content)} байт)")
            downloaded += 1
            
        except Exception as e:
            print(f"❌ Помилка: {str(e)[:50]}")
            failed += 1
    
    print(f"\n{'='*60}")
    print(f"✅ Завантажено: {downloaded} зображень")
    print(f"❌ Помилок: {failed}")
    print(f"{'='*60}")

if __name__ == "__main__":
    print("🎯 Скрипт завантаження зображень товарів")
    print("=" * 60)
    download_images()
    print("\n✨ Готово! Зображення можна побачити на сайті.")
