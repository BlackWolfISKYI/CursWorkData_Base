#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Створення локальних placeholder зображень для товарів
"""

from PIL import Image, ImageDraw, ImageFont
import os
from pathlib import Path

# Дані товарів
PRODUCTS = {
    1: {"name": "CYMA CM.028 AK47", "color": (44, 62, 80)},
    2: {"name": "G&G CM16 Raider", "color": (52, 73, 94)},
    3: {"name": "Tokyo Marui AK47", "color": (44, 62, 80)},
    4: {"name": "Specna Arms SA-C01", "color": (52, 73, 94)},
    5: {"name": "Cybergun FAMAS F1", "color": (44, 62, 80)},
    6: {"name": "Tokyo Marui Glock 17", "color": (26, 188, 156)},
    7: {"name": "Cybergun Colt 1911", "color": (22, 160, 133)},
    8: {"name": "ASG CZ P-09", "color": (26, 188, 156)},
    9: {"name": "WE Beretta M9", "color": (22, 160, 133)},
    10: {"name": "WELL MB4403D", "color": (142, 68, 173)},
    11: {"name": "Tokyo Marui VSR-10", "color": (155, 89, 182)},
    12: {"name": "Cybergun FN SPR", "color": (142, 68, 173)},
    13: {"name": "A&K PKM", "color": (192, 57, 43)},
    14: {"name": "G&P M249 SAW", "color": (231, 76, 60)},
    15: {"name": "Viper VX Buckle", "color": (39, 174, 96)},
    16: {"name": "8Fields Chest Rig", "color": (46, 204, 113)},
    17: {"name": "Pantac Mini MAP", "color": (39, 174, 96)},
    18: {"name": "Mil-Tec Assault 36L", "color": (127, 140, 141)},
    19: {"name": "Condor 3-Day Pack", "color": (149, 165, 166)},
    20: {"name": "Cytac CY-G17", "color": (211, 84, 0)},
    21: {"name": "Uncle Mike Holster", "color": (230, 126, 34)},
    22: {"name": "Pyramex I-Force", "color": (52, 152, 219)},
    23: {"name": "Emerson Steel Mesh", "color": (41, 128, 185)},
    24: {"name": "OneTigris Foldable", "color": (52, 152, 219)},
    25: {"name": "Valken Tango", "color": (41, 128, 185)},
    26: {"name": "Emerson FAST", "color": (52, 73, 94)},
    27: {"name": "FMA Maritime", "color": (44, 62, 80)},
    28: {"name": "G&G Bio BB 0.25g", "color": (236, 240, 241)},
    29: {"name": "BLS Precision 0.20g", "color": (236, 240, 241)},
    30: {"name": "Nuprol RZR 0.28g", "color": (236, 240, 241)},
    31: {"name": "ASG Blaster 0.12g", "color": (236, 240, 241)},
    32: {"name": "Element M300", "color": (243, 156, 18)},
    33: {"name": "Holosun HS403B", "color": (230, 126, 34)},
    34: {"name": "Element PEQ-15", "color": (243, 156, 18)},
    35: {"name": "Magpul RVG", "color": (230, 126, 34)},
    36: {"name": "UTG 4x32 Scope", "color": (243, 156, 18)},
}

FILENAMES = {
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

def create_placeholder_images():
    """Створює локальні placeholder зображення"""
    
    # Визначаємо папку
    images_dir = Path(__file__).parent / "web_app" / "static" / "images" / "products"
    images_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"📁 Створення зображень у: {images_dir}")
    print(f"🎨 Створюю {len(PRODUCTS)} placeholder зображень...\n")
    
    for product_id, product_info in PRODUCTS.items():
        filename = FILENAMES.get(product_id, f"product-{product_id}.jpg")
        filepath = images_dir / filename
        
        try:
            # Розміри зображення
            width, height = 500, 500
            
            # Создаємо нове зображення
            img = Image.new('RGB', (width, height), color=product_info["color"])
            draw = ImageDraw.Draw(img)
            
            # Додаємо текст
            text = product_info["name"]
            
            # Намагаємось використати шрифт, або використовуємо дефолтний
            try:
                font = ImageFont.truetype("arial.ttf", 24)
                small_font = ImageFont.truetype("arial.ttf", 16)
            except:
                font = ImageFont.load_default()
                small_font = ImageFont.load_default()
            
            # Рисуємо текст
            text_bbox = draw.textbbox((0, 0), text, font=font)
            text_width = text_bbox[2] - text_bbox[0]
            text_height = text_bbox[3] - text_bbox[1]
            
            x = (width - text_width) // 2
            y = (height - text_height) // 2
            
            draw.text((x, y), text, fill=(255, 255, 255), font=font)
            draw.text((20, height - 40), f"ID: {product_id}", fill=(200, 200, 200), font=small_font)
            
            # Зберігаємо зображення
            img.save(filepath, 'JPEG', quality=85)
            
            print(f"[{product_id:2d}] ✅ {filename}")
            
        except Exception as e:
            print(f"[{product_id:2d}] ❌ {filename}: {str(e)}")
    
    print(f"\n{'='*60}")
    print(f"✨ Готово! {len(PRODUCTS)} зображень створено!")
    print(f"{'='*60}")

if __name__ == "__main__":
    print("🖼️  Генератор placeholder зображень товарів")
    print("=" * 60)
    create_placeholder_images()
    print("\n📸 Зображення тепер можна побачити на сайті!")
