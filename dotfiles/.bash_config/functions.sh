#!/bin/bash

ll() {
    if [ "$#" -eq 0 ] || [[ ! $1 =~ ^[0-9]+$ ]]; then
        lsd --tree --depth 1 "$@"
    else
        depth="$1"
        shift
        lsd "$@" --tree --depth $depth
    fi
}

x11() {
    termux-x11 :0 -xstartup "dbus-launch --exit-with-session xfce4-session"
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}
