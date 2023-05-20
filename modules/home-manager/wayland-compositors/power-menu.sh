#!/usr/bin/env bash
set -eux

entries="suspend\nreboot\npoweroff"

selected=$(echo -e $entries|wofi --width 250 --height 150 --dmenu --cache-file /dev/null)

case $selected in
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  poweroff)
    exec systemctl poweroff -i;;
esac
