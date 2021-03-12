#!/bin/bash

rofi_command="rofi -theme themes/powermenu.rasi"

### Options ###
mobile=""
duplicate=""
external=""
dual=""
# Variable passed to rofi
options="$mobile\n$duplicate\n$external\n$dual"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    "$mobile")
        xrandr --output eDP-1 --auto --output HDMI-1 --off
        ;;
    "$duplicate")
        xrandr --output HDMI-1 --auto --output eDP-1 --same-as HDMI-1
        ;;
    "$external")
        xrandr --output eDP-1 --off --output HDMI-1 --auto
        ;;
    "$dual")
        xrandr --output eDP-1 --auto --output HDMI-1 --auto --above eDP-1
        ;;
esac

