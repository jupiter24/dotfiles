#!/usr/bin/env bash
# This script looks for Beeminders that are due tomorrow and adds corresponding
# Complice intentions. To add new beeminders, just add them at the bottom using
# the functions defined here.
set -euo pipefail

complice_token=$(pass complice/token)
beeminder_token=$(pass beeminder/token)
tomorrow=$(date -d "tomorrow" -u +"%Y-%m-%d")

getDueDate() {
    goal=$1
    curl -X GET "https://www.beeminder.com/api/v1/users/ejenner/goals/$goal.json" -d auth_token="$beeminder_token" | jq ".losedate" 
}

setIntention() {
    curl -X POST "https://complice.co/api/v0/u/me/intentions?auth_token=$complice_token" --data-urlencode raw="$1" -d "ymd=$tomorrow"
}

isDue() {
    if [[ $(getDueDate "$1") -le $(date -d "tomorrow 00:00 +1day" +%s) ]]; then
        return 0
    else
        return 1
    fi
}

if isDue "blog"; then setIntention "&) Publish blog post"; fi
if isDue "self-study"; then setIntention "4) Self-study: "; fi
if isDue "bugs"; then setIntention "1) Bug fixing: "; fi
if isDue "powerhour"; then setIntention "&) Power hour"; fi
if isDue "weekly_checklist"; then setIntention "&) Weekly checklist"; fi
if isDue "exercising"; then setIntention "3) Sport"; fi
if isDue "putzen"; then setIntention "&) Putzen + Aufräumen"; fi
