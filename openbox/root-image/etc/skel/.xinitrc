#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

desktop=$1

run_dwm(){
  xcompmgr -c -f -D 5 &
  xscreensaver --no-splash &
  exec dwm
}

run_spectrmw(){
  xcompmgr -c -f -D 5 &
  xscreensaver --no-splash &
  exec spectrmw
}



run_openbox(){
  exec dbus-launch --exit-with-session openbox
}


if [[ $desktop == dwm ]]; then
      run_dwm
elif [[ $desktop == spectrwm ]]; then
      run_spectrwm
else
      run_openbox
fi
