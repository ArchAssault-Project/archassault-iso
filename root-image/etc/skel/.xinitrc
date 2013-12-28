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
  hsetroot -fill /usr/share/wallpapers/ba_wallpaper.jpg &
  xcompmgr -c -f -D 5 &
  xautolock -time 10 -locker slock
  exec dwm
}

run_spectrmw(){
  hsetroot -fill /usr/share/wallpapers/ba_wallpaper.jpg &
  xcompmgr -c -f -D 5 &
  xautolock -time 10 -locker slock
  exec spectrmw
}



run_openbox(){
  exec openbox-session
}


if [[ $desktop == dwm ]]; then
      run_dwm
elif [[ $desktop == spectrwm ]]; then
      run_spectrwm
else
      run_openbox
fi
