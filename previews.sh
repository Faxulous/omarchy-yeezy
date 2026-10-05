#!/bin/bash
# Draw themes/yeezy-<slug>/preview.png for the theme picker: the first wallpaper with a mock bar and terminal in the theme's colours.
set -euo pipefail
cd "$(dirname "$0")"

REG=/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf
BOLD=/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Bold.ttf

for dir in themes/yeezy-*/; do
  declare -A C=()
  while IFS=$'\t' read -r key value; do C[$key]=$value; done < <(omarchy-theme-color --file "$dir/colors.toml" --all)
  wall=$(find "$dir/backgrounds" -type f | sort | head -1)
  title=$(basename "$dir" | sed 's/-/ /g; s/\b./\u&/g')

  text=()
  t() { text+=(-fill "${C[$1]}" -annotate "+$2+$3" "$4"); }
  t blue 90 165 '~/yeezy'; t accent 190 165 '>'; t foreground 220 165 'git status -s'
  t green 90 205 'A  backgrounds/01.jpg'
  t red 90 245 ' M colors.toml'
  t light_foreground 90 285 '?? preview.png'
  t blue 90 345 '~/yeezy'; t accent 190 345 '>'; t foreground 220 345 'ls'
  t blue 90 385 'backgrounds/'; t foreground 270 385 'colors.toml'; t magenta 440 385 'preview.png'; t cyan 610 385 'current@'
  t yellow 90 445 'warning:'; t foreground 210 445 'no unlock.png, using default'
  t orange 90 485 'orange'; t brown 190 485 'brown'; t light_foreground 290 485 '# comment'
  t light_foreground 1124 150 'theme'; t foreground 1124 232 'Catppuccin Latte'; t foreground 1124 310 'Flexoki Light'; t foreground 1124 350 'White'

  magick "$wall" -resize 1800x1125! \
    -fill "${C[background]}" -draw 'rectangle 0,0 1800,34' \
    -stroke "${C[accent]}" -strokewidth 3 -draw 'rectangle 60,110 1060,640' \
    -stroke "${C[muted]}" -draw 'rectangle 1100,110 1500,400' -stroke none \
    -fill "${C[selection]}" -draw 'rectangle 1116,246 1484,284' \
    -font "$BOLD" -pointsize 17 -fill "${C[accent]}" -annotate +22+23 1 \
    -font "$REG" -fill "${C[dark_foreground]}" -annotate +50+23 '2  3  4' -fill "${C[foreground]}" -annotate +830+23 'Monday 17:52' \
    -pointsize 21 "${text[@]}" \
    -font "$BOLD" -fill "${C[bright_foreground]}" -annotate +1124+272 "$title" \
    -strip "$dir/preview.png"
  echo "preview: $(basename "$dir")"
done
