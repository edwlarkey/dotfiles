[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources


#bspwm is default

WM=${2:-bspwm}

case $WM in
  awesome ) exec awesome;;
  i3      ) exec i3;;
  bspwm   )
    sxhkd &
    dunst &
    dzen &
    chromium &
    hipchat &
    exec bspwm;;
  *) exec $2;;
esac

setxkbmap -option ctrl:nocaps
