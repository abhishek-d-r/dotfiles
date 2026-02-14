#!/usr/bin/env bash

MODE=$1 # full | area | clipboard | annotate

BASE_DIR="$HOME/Pictures/Screenshots"
DATE=$(date +'%Y-%m-%d')
TIME=$(date +'%H-%M-%S')
DIR="$BASE_DIR/$DATE"
FILE="$DIR/$TIME.png"

mkdir -p "$DIR"

case $MODE in
full)
  grim "$FILE"
  notify-send "📸 Screenshot Saved" "$FILE"
  ;;
area)
  grim -g "$(slurp)" "$FILE"
  notify-send "📸 Area Screenshot Saved" "$FILE"
  ;;
clipboard)
  grim -g "$(slurp)" - | wl-copy
  notify-send "📋 Screenshot Copied to Clipboard"
  ;;
annotate)
  grim -g "$(slurp)" - | swappy -f - -o "$FILE"
  notify-send "🖊 Screenshot Saved (Annotated)" "$FILE"
  ;;
esac
