#!/bin/bash

rofi_command="rofi -theme themes/powermenu.rasi"

### Options ###
on=""
off=""
headphones=""
# Variable passed to rofi
options="$on\n$headphones\n$off"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 1)"
case $chosen in
    "$on")
        bluetoothctl -- power on
	;;
    "$off")
        bluetoothctl -- power off
        ;;
    "$headphones")
        bluetoothctl -- power on
        bluetoothctl -- trust 50:18:11:99:98:D5
        bluetoothctl -- connect 50:18:11:99:98:D5
        ;;
esac
