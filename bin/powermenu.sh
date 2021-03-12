#!/bin/bash

rofi_command="rofi -theme themes/powermenu.rasi"

### Options ###
power_off=""
#reboot=""
lock=""
suspend="鈴"
log_out=""
good_night="⏾"
# Variable passed to rofi
options="$power_off\n$good_night\n$lock\n$suspend\n$log_out"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    "$power_off")
        systemctl poweroff
        ;;
    "$good_night")
        go_to_sleep.sh
        ;;
    "$lock")
        lock.sh
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$log_out")
        i3-msg exit
        ;;
esac

