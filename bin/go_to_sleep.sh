#!/bin/bash
set -euo pipefail

# the program is called telegram-desktop but that's longer than 16 characters
# which means the name is treated as "telegram-deskto"
pkill telegram-deskto
#killall slack
mpc pause
#zenity --info --text "Don't forget to hide the mail checker"

# check whether the current time is before the time described in
# ~/.productivity/bedtime.txt (which should just contain a time like "22:35",
# "2235" or "10pm")
# date is kind of magic and can interpret strings like "22:35 today +1hour"
if [[ $(date +%s) -le $(date -d "$(cat ~/.productivity/bedtime_today.txt) today" +%s) ]]; then
    val=1
    text="Nice, you're on time!"
    color="green"
else
    val=0
    text="It's after your planned bedtime."
    color="red"
fi
curl -X POST https://www.beeminder.com/api/v1/users/ejenner/goals/bedtime/datapoints.json \
    -d auth_token="$(pass beeminder/token)" \
    -d value=$val \
    -d comment=via+shutdown+script \
    &>> ~/.productivity/beeminder.log
dialog.sh "$text" "Now open the necessary files for your first intention tomorrow." "$color"
welcome_screen.sh &
systemctl suspend
