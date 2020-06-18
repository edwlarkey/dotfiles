#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
if [[ $(bspc query -M |wc -l) == '2' ]]; then
  polybar top &
  polybar top-right &
  polybar top2-right &
  polybar bottom &
  polybar bottom-right &
else
  polybar top &
  polybar top-right &
  polybar bottom &
  polybar bottom-right &
fi
