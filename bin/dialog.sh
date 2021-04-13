#!/usr/bin/env bash
set -euo pipefail

convert -size 800x600 \
    canvas:"${3:-white}" \
	-gravity North \
	-pointsize 50 \
	-annotate +0+100 "$1" \
    -pointsize 25 \
	-annotate +0+300 "${2:-}" \
    -bordercolor black -border 10 \
	~/.productivity/dialog.jpg
feh -x -g 810x610 --title "feh dialog" ~/.productivity/dialog.jpg
