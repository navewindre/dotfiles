#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
#
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS='@im=ibus'
xrandr --output DP-0 --mode 1920x1080 --rate 165
xrandr --output DP-0 --mode 1280x1024 --rate 75
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
. /etc/X11/Xsession
