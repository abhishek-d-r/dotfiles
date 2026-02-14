#!/bin/bash
# Start GNOME Keyring Daemon
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
# /usr/libexec/polkit-gnome-authentication-agent-1 &
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
