#!/bin/bash
REQUIRED_CMDS=(hyprctl jq uwsm swaybg pkill)

# Check if required dependencies are installed
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd; install it before running this script."
    exit 1
  fi
done

# Check if hyprctl is running
if ! hyprctl info >/dev/null 2>&1; then
  echo "Hyprland does not appear to be running (hyprctl info failed)."
  exit 1
fi

MONITORS=($(hyprctl monitors -j | jq -r '.[].name'))

# Kill all swaybg processes and discards any error messages
pkill -x swaybg 2>/dev/null
sleep 0.2

# Dynamic wallpaper setup
if [ "${#MONITORS[@]}" -eq 1 ]; then
  uwsm app -- setsid swaybg \
    -o "${MONITORS[0]}" -i ~/.config/backgrounds/group_of_pink_flowers.jpg -m fill
else
  uwsm app -- setsid swaybg \
    -o "${MONITORS[0]}" -i ~/.config/backgrounds/astronaut_playing_a_piano.jpg -m fill \
    -o "${MONITORS[1]}" -i ~/.config/backgrounds/group_of_pink_flowers.jpg -m fill
fi

