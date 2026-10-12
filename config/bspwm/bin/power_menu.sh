#!/bin/bash

# icons
lock="󰌾"
logout="󰗽"
reboot="󰜉"
poweroff="󰐥"

chosen=$(printf '%s\n%s\n%s\n%s\n' "$lock" "$logout" "$reboot" "$poweroff" | rofi -dmenu -i -window-title powermenu)

case "$chosen" in
"$lock")
  i3lock
  ;;
"$logout")
  loginctl terminate-user "$USER"
  ;;
"$reboot")
  systemctl reboot
  ;;
"$poweroff")
  systemctl poweroff
  ;;
esac
