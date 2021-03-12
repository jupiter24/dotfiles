#!/bin/bash
# passes a list of all files in ~/Documents to rofi to select one
# -L means that find follows symbolic links
# -p is the prompt that will be displayed. -i makes rofi case insensitive
# cut is used to remove /home/erik/Documents/ at the beginning of each path
# The selected file is opened with the default application using xdg-open
filename=$(find -L ~/Documents | cut -d'/' -f5- | rofi -dmenu -i -theme themes/appsmenu.rasi -sorting-method fzf -p files)
# Only open a file if one was selected. Otherwise, /home/erik/Documents would be opened
if [ $? -eq 0 ]; then
    xdg-open "/home/erik/Documents/$filename"
fi
