#!/bin/bash
# Copy the built themes into ~/.config/omarchy/themes so `omarchy theme set "Yeezy <Name>"` can find them.
set -euo pipefail
cd "$(dirname "$0")"

dest="$HOME/.config/omarchy/themes"
mkdir -p "$dest"
for theme in themes/yeezy-*/; do
  name=$(basename "$theme")
  rm -rf "${dest:?}/$name"
  cp -r "$theme" "$dest/$name"
  echo "installed $name"
done
