[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources


#bspwm is default

WM=${2:-bspwm}

case $WM in
  awesome ) exec awesome;;
  i3      ) exec i3;;
  bspwm   )
    xrandr --output HDMI-0 --auto --primary
    xrandr --output DVI-I-1 --auto --right-of HDMI-0
    sxhkd &
    # dunst &
    dzen &
    chromium &
    # hipchat &
    setxkbmap -option caps:ctrl
    xinput set-ptr-feedback 10 800 800 400
    exec bspwm;;
  *) exec $2;;
esac

setxkbmap -option caps:ctrl
