#!/bin/bash
# Crop and grade the source photographs into themes/yeezy-<slug>/backgrounds/<n>-<name>.jpg at 3200x2000.
# Sources live in sources/<era>-<slug>/ (see CREDITS.md); the grade only softens: slightly lifted blacks,
# a little less saturation, and a hue nudge where the photo's colour is off the palette.
set -euo pipefail
cd "$(dirname "$0")"

# slug | out name | source | gravity | zoom | brightness | saturation | hue | black lift % | tint colour | tint %
TABLE='
murakami|1-lilac-cloud|graduation-murakami/01.jpg|center|1|100|90|100|3||
murakami|2-cotton-candy|graduation-murakami/02.jpg|center|1|102|85|100|3||
murakami|3-violet-bank|graduation-murakami/03.jpg|north|1|108|85|100|6||
murakami|4-gold-rim|graduation-murakami/04.jpg|center|1|102|65|100|4||
good-morning|1-above-clouds|graduation-good-morning/01.jpg|center|1|100|90|100|3||
good-morning|2-powder|graduation-good-morning/02.jpg|center|1|100|95|100|2||
good-morning|3-apricot-cloud|graduation-good-morning/03.jpg|southeast|1.06|100|88|100|3||
good-morning|4-cream-clouds|graduation-good-morning/04.jpg|center|1|102|80|100|3||
flashing-lights|1-basin|graduation-flashing-lights/01.jpg|center|1|100|85|100|3||
flashing-lights|2-white-dunes|graduation-flashing-lights/03.jpg|center|1|108|95|100|5||
flashing-lights|3-road|graduation-flashing-lights/02.jpg|north|1.25|102|88|100|8||
flashing-lights|4-red-rock|graduation-flashing-lights/04.jpg|north|1.2|102|85|100|8||
dropout-bear|1-cream-fur|graduation-dropout-bear/02.jpg|center|1|100|95|100|2||
dropout-bear|2-caramel-fur|graduation-dropout-bear/01.jpg|center|1|105|92|100|5||
dropout-bear|3-wool|graduation-dropout-bear/03.jpg|center|1|100|100|100|2||
dropout-bear|4-fleece|graduation-dropout-bear/04.jpg|center|1|108|85|100|5||
sleeve|2-balloons|808s-sleeve/01.jpg|center|1|100|85|100|2||
sleeve|1-plaster|808s-sleeve/04.jpg|center|1|100|100|100|0||
sleeve|3-heart|808s-sleeve/03.jpg|center|1|100|80|100|2|#d8dbdd|10
love-lockdown|1-window-light|808s-love-lockdown/01.jpg|center|1|98|100|100|0||
love-lockdown|2-white-room|808s-love-lockdown/02.jpg|center|1|104|100|100|0||
love-lockdown|3-pane-shadow|808s-love-lockdown/03.jpg|center|1|106|100|100|0||
love-lockdown|4-recess|808s-love-lockdown/04.jpg|center|1|100|100|100|0||
heartless|1-haze|808s-heartless/02.jpg|center|1|100|95|100|3||
heartless|2-griffith|808s-heartless/01.jpg|north|1|110|90|100|12||
heartless|3-downtown|808s-heartless/03.jpg|north|1|114|82|100|16||
coldest-winter|1-pine|808s-coldest-winter/02.jpg|center|1|100|100|100|0||
coldest-winter|2-spruce|808s-coldest-winter/01.jpg|center|1|100|100|100|0||
coldest-winter|3-bare-tree|808s-coldest-winter/03.jpg|north|1.08|100|100|100|2||
jewel-case|1-acrylic|yeezus-jewel-case/01.jpg|center|1|100|100|100|0||
jewel-case|2-cube|yeezus-jewel-case/03.jpg|center|1|100|80|100|0||
jewel-case|3-discs|yeezus-jewel-case/02.jpg|center|1|112|100|100|10||
jewel-case|4-glass|yeezus-jewel-case/04.jpg|center|1|102|100|100|6||
mountain|1-peak|yeezus-mountain/01.jpg|center|1|100|80|100|2|#efe6d8|8
mountain|2-fog-peak|yeezus-mountain/02.jpg|center|1|100|55|100|2|#efe6d8|10
mountain|3-summit|yeezus-mountain/03.jpg|north|1.12|100|70|100|2|#efe6d8|8
mountain|4-gypsum|yeezus-mountain/04.jpg|center|1|104|40|100|3|#efe6d8|10
slide|1-ripples|season-slide/01.jpg|center|1|100|100|100|0||
slide|2-plaster|season-slide/02.jpg|northwest|1.1|100|100|100|2||
slide|3-dunes|season-slide/03.jpg|south|1.1|102|85|100|3||
slide|4-fine-sand|season-slide/04.jpg|center|1|100|100|100|0|#e9e6dc|8
black-square|1-window|donda-black-square/01.jpg|center|1|100|100|100|6|#f2efe8|6
black-square|2-door|donda-black-square/02.jpg|center|1|100|80|100|8||
black-square|3-hatch|donda-black-square/03.jpg|center|1|102|45|100|8||
black-square|4-frame|donda-black-square/04.jpg|center|1|100|100|100|12|#f2efe8|6
perfect-hoodie|1-rib|donda-perfect-hoodie/01.jpg|center|1|100|80|112|2||
perfect-hoodie|2-fleece|donda-perfect-hoodie/03.jpg|center|1|98|120|128|2||
perfect-hoodie|3-fold|donda-perfect-hoodie/02.jpg|center|1|118|62|104|8||
perfect-hoodie|4-slate|donda-perfect-hoodie/04.jpg|center|1|118|110|112|6||
bourgeois|1-wash|donda-bourgeois/01.jpg|center|1|100|95|100|0||
bourgeois|2-bleed|donda-bourgeois/02.jpg|center|1|100|88|100|0|#f6f1ea|6
bourgeois|3-disc|donda-bourgeois/03.jpg|center|1|100|82|100|0|#f6f1ea|6
bourgeois|4-ink|donda-bourgeois/04.jpg|center|1|100|58|100|0|#f6f1ea|8
childhood-home|1-prairie|donda-childhood-home/02.jpg|center|1|100|90|100|3||
childhood-home|2-moor|donda-childhood-home/01.jpg|center|1|116|85|100|10||
childhood-home|3-hut|donda-childhood-home/04.jpg|center|1|100|90|100|0||
childhood-home|4-lamps|donda-childhood-home/03.jpg|east|1.08|116|90|100|12||
'

grade() {
  IFS='|' read -r slug name src gravity zoom bri sat hue lift tint tintamt <<<"$1"
  local w h out="themes/yeezy-$slug/backgrounds/$name.jpg"
  w=$(awk "BEGIN{print int(3200*$zoom)}") h=$(awk "BEGIN{print int(2000*$zoom)}")
  local extra=()
  [[ -n $tint ]] && extra=(-fill "$tint" -colorize "$tintamt")
  magick "sources/$src" -auto-orient -filter Lanczos -resize "${w}x${h}^" -gravity "$gravity" -extent 3200x2000 \
    -modulate "$bri,$sat,$hue" +level "${lift}%,100%" "${extra[@]}" \
    -attenuate 0.04 +noise Gaussian -strip -quality 93 "$out"
  echo "photo: $slug/$name"
}
export -f grade

rm -f themes/yeezy-*/backgrounds/[1-8]-*.jpg
grep '|' <<<"$TABLE" | xargs -P 6 -d '\n' -I{} bash -c 'grade "$1"' _ {}

# Malevich's Black Square (1915, public domain) hung on a paper-coloured field
magick -size 3200x2000 xc:'#ecebe7' \
  \( sources/donda-black-square/malevich.jpg -resize 1040x1040 -modulate 100,60 +level 8%,100% \
     \( +clone -background '#00000055' -shadow 60x18+0+14 \) +swap -background none -layers merge +repage \) \
  -gravity center -composite -attenuate 0.04 +noise Gaussian -strip -quality 93 \
  themes/yeezy-black-square/backgrounds/5-malevich.jpg
echo "photo: black-square/5-malevich"
