#!/usr/bin/env bash
# Save/load CWD directories ↔ ~/.config , completely skipping every .git dir
set -euo pipefail

CONFIG_DIR="$HOME/.config"

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
usage(){ echo "Usage: $0 [--save|--load]"; exit 0; }

[[ $# -eq 1 ]] || usage
mkdir -p "$CONFIG_DIR"

case "$1" in
  --save)
    for dir in */; do                 # */ matches only directories
      [[ -d $dir ]] || continue       # paranoia
      echo "Saving $dir  ->  $CONFIG_DIR/"
      rsync -a --exclude=.git "$dir" "$CONFIG_DIR/"
    done
    ;;
  --load)
    for dir in */; do
      src="$CONFIG_DIR/${dir%/}"
      [[ -d $src ]] || continue
      echo "Loading $src  ->  ./$dir"
      rsync -a --exclude=.git "$src"/ "${dir%/}"
    done
    ;;
  *) usage ;;
esac
