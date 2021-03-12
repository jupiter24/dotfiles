export PATH=~/bin:~/.emacs.d/bin:$PATH
eval $(keychain --noask --eval --quiet id_ed25519)

# Automatically start X on VT 1
# $DISPLAY is checked to prevent X from being started when it's already running
# $XDG_VTNR is set by systemd so this will only work on systems running systemd!
# To stay logged in after the X session has ended, remove the 'exec'
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx
fi
