#!/usr/bin/env bash

ip_array=()
ip addr show dev wg-mullvad >/dev/null 2>&1 && CONNECTED=1

if [ -n "$CONNECTED" ]; then
  for IP in $(ip addr show dev wg-mullvad | awk '/inet/ { print $2 }' | cut -d '/' -f1); do
    ip_array+=("$IP")
  done
  #printf '{"text": "%s ' "${ip_array[@]}" '" "alt": "connected"}'
  echo -n '{"text":' "\"${ip_array[*]}\"," '"class": "custom-connected", "alt": "connected"}'
else
  echo -n '{"text": "Not Connected", "class": "custom-disconnected", "alt": "disconnected"}'
fi
