[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources


#xfce is default
WM=${2:-xfce}

case $WM in
  awesome ) exec awesome;;
  i3      ) exec i3;;
  xfce    ) 
    export XDG_SESSION_TYPE=X11
    plank &
    redshift -l 41.20 -95.99 -t 6000 4500 -b 1.00 0.99 &
    xmodmap dotfiles/xmodmap
    exec startxfce4;;
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
