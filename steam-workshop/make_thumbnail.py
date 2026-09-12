"""Rebuilds thumbnail.png (Workshop preview) and thumbnail-200px.png (a legibility check
at Steam's listing size, not uploaded). Layout lives in thumbnail_layout.py."""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from thumbnail_layout import make

OLD = "/home/nikita/Pictures/Screenshots/Screenshot_20260913_004937.png"  # procedural snow, Sharp Terrain alone
NEW = "/home/nikita/Pictures/Screenshots/Screenshot_20260913_004808.png"  # snow material, this add-on
CROP = (1500, 280, 3620, 1133)   # 2120x853, the Gulf of Finland, clear of every UI element
OUT = os.path.join(os.path.dirname(__file__), "..", "thumbnail.png")
make(OUT, "REAL SNOW", OLD, NEW, CROP, CROP)
