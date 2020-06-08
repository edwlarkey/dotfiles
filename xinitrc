[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources


#kde is default
WM=${2:-bspwm}

case $WM in
  awesome ) exec awesome;;
  i3      ) exec i3;;
  xfce    )
    export XDG_SESSION_TYPE=X11
    plank &
    redshift -l 41.20 -95.99 -t 6000 4500 -b 1.00 0.99 &
    xmodmap dotfiles/xmodmap
    exec startxfce4;;
  kde    )
    redshift -l 41.20 -95.99 -t 6000 4500 -b 1.00 0.99 &
    xmodmap dotfiles/xmodmap
    exec startplasma-x11;;
  bspwm   )
    # xrandr --output DP-1 --auto --primary
    # xrandr --output HDMI-1 --auto --right-of DP-1
    # xrandr --dpi 163
    xrandr \
     --dpi 163 \
     --output DP-1 --mode 3840x2160 --rate 60 --pos 0x0 --primary \
     --output HDMI-1 --mode 2560x1080 --rate 60 --pos 3840x0 \
     --output DVI-D-1 --off \
     --output DVI-D-2 --off
    redshift -l 41.20 -95.99 -t 6000 4500 -b 1.00 0.99 &
    xsetroot -cursor_name left_ptr &
    setxkbmap -option caps:ctrl
    xinput set-ptr-feedback 10 800 800 400
    exec bspwm;;
  *) exec $2;;
esac

setxkbmap -option caps:ctrl
