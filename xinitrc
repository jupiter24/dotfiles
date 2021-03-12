#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# Run scripts in /etc/X11/xinit/xinitrc.d/

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# set keyboard layout to US international
# Ctrl-Alt-Backspace to termiante X is enabled
setxkbmap -layout us,gr -variant altgr-intl,basic -option grp:shifts_toggle

# typematic delay and rate:
# 250ms delay and 40 Hz rate
xset r rate 250 40

# Start udiskie to automount USB drives.
# Show notifications, tray and enable automount
udiskie --tray &

# Start lxpolkit (shows graphical authentication dialog when required by polkit)
lxpolkit &
# Use feh to show the background image that was last used
~/.fehbg &

# Lock the screen
lock_wallpaper.sh
# Start i3 window manager
exec i3
