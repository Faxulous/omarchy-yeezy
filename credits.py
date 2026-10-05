#!/usr/bin/env python3
"""Write CREDITS.md from the photo table in photos.sh and the manifests in sources/."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).parent
rows = re.findall(r"^([a-z-]+)\|([\w-]+)\|([\w-]+)/(\S+?\.jpg)\|", (ROOT / "photos.sh").read_text(), re.M)
rows.append(("black-square", "5-malevich", "donda-black-square", "malevich.jpg"))

out = ["# Wallpaper credits\n",
       "Every photograph was cropped to 3200x2000 and colour-graded for its theme; none is an unaltered copy.",
       "The `9-graphic.jpg` wallpapers were drawn for this project.\n",
       "| Theme | Wallpaper | Photographer | Source | Licence |", "|---|---|---|---|---|"]
for slug, name, folder, file in sorted(rows):
    manifest = json.loads((ROOT / "sources" / folder / "manifest.json").read_text())
    m = next(x for x in manifest if x["file"] == file)
    licence = (m.get("licence") or m.get("license")).split(" (")[0]
    out.append(f"| yeezy-{slug} | `{name}.jpg` | {m['author']} | {m['source_url']} | {licence} |")
(ROOT / "CREDITS.md").write_text("\n".join(out) + "\n")
print(f"credited {len(rows)} photographs")
