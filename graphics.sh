#!/bin/bash
# Draw the flat "graphic" wallpaper for each theme into themes/yeezy-<slug>/backgrounds/9-graphic.jpg.
# Soft fields are built small, blurred and scaled up so gradients stay smooth; hard shapes are drawn at full size.
set -euo pipefail
cd "$(dirname "$0")"

W=3200 H=2000

# soft <slug> <magick args building a 400x250 image>  -> full-size smooth field on stdout as miff
soft() { magick -size 400x250 "$@" -blur 0x14 -filter Cubic -resize ${W}x${H}! -depth 16 miff:-; }

# finish <slug> [extra full-size draw args]: read miff on stdin, draw, add grain, write jpg
finish() {
  local slug=$1; shift
  magick miff:- "$@" -attenuate 0.12 +noise Gaussian -depth 8 -quality 95 \
    "themes/yeezy-$slug/backgrounds/9-graphic.jpg"
  echo "graphic: $slug"
}

# vertical gradient through colour stops: vgrad c1 pct c2 pct c3 ...  (pct = where the next colour lands, 0-100)
vgrad() {
  local args=() prev=$1 at=0; shift
  while (($#)); do
    local pct=$1 col=$2; shift 2
    args+=( \( -size 400x$(( (pct - at) * 250 / 100 )) gradient:"$prev-$col" \) )
    prev=$col at=$pct
  done
  magick "${args[@]}" -append -resize 400x250! -blur 0x6 -filter Cubic -resize ${W}x${H}! -depth 16 miff:-
}

vgrad '#a58ad6' 62 '#ecaac8' 100 '#f7d3a4' | finish murakami
vgrad '#a9d0ec' 60 '#fbdcc2' 100 '#fbb794' | finish good-morning
vgrad '#8f84ad' 55 '#dba3a0' 82 '#f1cba0' 100 '#c9a688' | finish flashing-lights
vgrad '#8a86b4' 55 '#c0a2c8' 100 '#ecc0b8' | finish heartless
vgrad '#e2eaf1' 100 '#b7c7d7' | finish coldest-winter

soft xc:'#c39a68' -fill '#dcb888' -draw 'ellipse 200,100 150,95 0,360' | finish dropout-bear
soft xc:'#93a2c4' -fill '#a4b3d2' -draw 'ellipse 150,90 190,120 0,360' | finish perfect-hoodie
soft xc:'#f4ebe2' -fill '#eeb1b3' -draw 'ellipse 200,160 95,60 0,360' -fill '#df7f86' -draw 'ellipse 200,165 42,26 0,360' | finish bourgeois
soft xc:'#848b9a' -fill '#9aa0ad' -draw 'ellipse 200,150 170,110 0,360' -fill '#cdb692' -draw 'ellipse 200,150 48,30 0,360' -fill '#f3d28a' -draw 'ellipse 200,150 10,7 0,360' | finish childhood-home

# 808s sleeve: grey field, six pastel bars down the left edge
soft xc:'#c4c8cb' | finish sleeve \
  -fill '#e7a0b0' -draw 'rectangle 0,0 54,333' -fill '#eebb92' -draw 'rectangle 0,334 54,666' \
  -fill '#ecd896' -draw 'rectangle 0,667 54,1000' -fill '#a5cdb2' -draw 'rectangle 0,1001 54,1333' \
  -fill '#9cc6d8' -draw 'rectangle 0,1334 54,1666' -fill '#bdb1da' -draw 'rectangle 0,1667 54,2000'

# Love Lockdown: white field, one small heart
soft xc:'#efede9' | finish love-lockdown -fill '#d8505e' \
  -draw "path 'M 1600,1190 C 1540,1130 1500,1100 1500,1058 C 1500,1022 1528,1000 1556,1000 C 1576,1000 1592,1012 1600,1028 C 1608,1012 1624,1000 1644,1000 C 1672,1000 1700,1022 1700,1058 C 1700,1100 1660,1130 1600,1190 Z'"

# Jewel case: pale disc with a spindle hole, one strip of tape from the top edge
soft xc:'#d2d7d8' | finish jewel-case \
  -fill '#e3e7e8' -draw 'circle 1600,1060 1600,620' -fill '#d2d7d8' -draw 'circle 1600,1060 1600,1004' \
  -fill '#d9483c' -draw 'rectangle 2736,0 2846,430'

# Mountain: one chalk peak
soft xc:'#d3d5d6' | finish mountain -fill '#f6f4f0' -draw 'polygon 1600,470 2640,2000 560,2000'

# Slide: Bone, Resin, Pure
soft xc:'#dfd9ca' | finish slide -fill '#a3ac9b' -draw 'rectangle 1067,0 2133,2000' -fill '#cfbea6' -draw 'rectangle 2134,0 3200,2000'

# Black square
soft xc:'#e6e5e1' | finish black-square -fill '#2a2a2a' -draw 'rectangle 1280,680 1920,1320'
