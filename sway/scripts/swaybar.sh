#!/bin/bash
# Change this according to your device
################
# Variables
################

# Keyboard input name
keyboard_input_name="1:1:AT_Translated_Set_2_keyboard"

# Date and time
date=$(date "+%Y/%m/%d")
current_time=$(date "+%H:%M")

#############
# Commands
#############

# Battery or charger
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')

# Audio and multimedia
audio_volume=$(wpctl get-volume @DEFAULT_SINK@ | awk -F'[[:space:]:[]' '/Volume:/ {print int($3*100)}')
audio_is_muted=$(wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED && echo true || echo false)

# Network
active_wifi=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
# Others
language=$(swaymsg -r -t get_inputs | awk '/1:1:AT_Translated_Set_2_keyboard/;/xkb_active_layout_name/' | grep -A1 '\b1:1:AT_Translated_Set_2_keyboard\b' | grep "xkb_active_layout_name" | awk -F '"' '{print $4}')

if [ $battery_status = "discharging" ];
then
    battery_pluggedin='⚠'
else
    battery_pluggedin='⚡'
fi

if ! [ $active_wifi ]
then
   network_active="⛔"
else
   network_active="⇆"
fi

if [ $audio_is_muted = "true" ]
then
    audio_active='🔇'
else
    audio_active='🔊'
fi

echo "⌨ $language | $network_active $active_wifi | $audio_active $audio_volume% | $battery_pluggedin $battery_charge | $date 🕘 $current_time"
