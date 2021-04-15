#!/bin/bash

convert ~/Pictures/wallpapers/morning_flowers.jpg \
	-fill "#0008" \
	-draw "rectangle 310,0 1610,1080" \
	-gravity North \
	-pointsize 100 \
	-fill "#ccc" \
	-annotate +0+100 "Good morning, Erik!" \
	-interline-spacing 30 \
	-pointsize 40 \
	-fill "#aaa" \
	-gravity North \
	-annotate 0x15+0+250 "Better today than we were yesterday,\nbetter tomorrow than we are today." \
	-fill white \
	-gravity Northwest \
	-pointsize 40 \
	-annotate +340+460 "Your top priority for today is:" \
	-gravity North \
	-pointsize 70 \
	-annotate +0+550 "$(cat ~/.productivity/daily_message.txt )" \
	~/.productivity/welcome.jpg
feh -Z -F ~/.productivity/welcome.jpg

