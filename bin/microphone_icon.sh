#!/usr/bin/env bash
# Stolen from https://hagen.dev/kristoffer/dotfiles/src/branch/master/.config/polybar/microphone.sh

get_status_icon() {
    if [[ $(pamixer --default-source --get-mute | grep "true") ]]; then
        # echo "%{F#be5046}  %{F-}"
        echo ""
    else
         echo ""
    fi
}

get_status_icon

while read line; do
    if [[ $line == "Event 'change' on source "* ]]; then
        get_status_icon
    fi
done < <(pactl subscribe)
