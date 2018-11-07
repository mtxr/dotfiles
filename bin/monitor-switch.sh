#!/bin/sh

# Get out of town if something errors
# set -e

# Get info on the monitors
LAPTOP_STATUS=$(</sys/class/drm/card0/card0-eDP-1/status)

HDMI_STATUS=$(</sys/class/drm/card0/card0-HDMI-A-1/status)
HDMI_ENABLED=$(</sys/class/drm/card0/card0-HDMI-A-1/enabled)

if [ -d /sys/class/drm/card0/card0-VGA-1/ ];then
  VGA_STATUS=$(</sys/class/drm/card0/card0-VGA-1/status)
  VGA_ENABLED=$(</sys/class/drm/card0/card0-VGA-1/enabled)
fi

if [ ! -f /tmp/monitor ]; then
    touch /tmp/monitor
    STATE=1
else
    STATE=$(</tmp/monitor)
fi


echo "STATE=${STATE}

LAPTOP_STATUS=$LAPTOP_STATUS
HDMI_STATUS=$HDMI_STATUS
HDMI_ENABLED=$HDMI_ENABLED
VGA_STATUS=$VGA_STATUS
VGA_ENABLED=$VGA_ENABLED
"

create_mode_if_not_exists () {
  local MODE_NAME=1680x944_custom
  xrandr | grep $MODE_NAME &> /dev/null && return 0
  xrandr --newmode "$MODE_NAME" 130.50 1680 1776 1952 2224 944 947 957 980 -hsync +vsync
  xrandr --addmode eDP-1 $MODE_NAME
  xrandr -s $MODE_NAME --output eDP-1
  echo "Mode $MODE_NAME created"
  return 0
}

create_mode_if_not_exists

# Check to see if our state log exists
# The state log has the NEXT state to go to in it

# If monitors are disconnected, stay in state 1
if [ "disconnected" == "$HDMI_STATUS" -a "disconnected" == "$VGA_STATUS" ]; then
    STATE=1
fi
echo "STATE $STATE"

case $STATE in
    1)
    echo 'On state 1'
    # eDP is on, projectors not connected
    /usr/bin/xrandr --output eDP-1 --primary --mode 1680x944_custom --scale 1x1 --auto
    STATE=2
    ;;
    2)
    echo 'On state 2'
    # eDP is on, projectors are connected but inactive
    if [ "enabled" == "$HDMI_ENABLED" -a "enabled" == "$VGA_ENABLED" ]; then
        /usr/bin/xrandr --output eDP-1 --primary --mode 1680x944_custom --scale 1x1 --auto --output HDMI-1 --off --output VGA-1 --off
        STATE=3
    elif [ "enabled" == "$HDMI_ENABLED" ]; then
        /usr/bin/xrandr --output eDP-1 --primary --mode 1680x944_custom --scale 1x1 --auto --output HDMI-1 --off
        STATE=3
    elif [ "enabled" == "$VGA_ENABLED" ]; then
        /usr/bin/xrandr --output eDP-1 --primary --mode 1680x944_custom --scale 1x1 --auto --output VGA-1 --off
        STATE=3
    else
        /usr/bin/xrandr --output eDP-1 --primary --mode 1680x944_custom --scale 1x1 --auto
        STATE=1
    fi
    ;;
    3)
    echo 'On state 3'
    # eDP is off, projectors are on
    if [ "connected" == "$HDMI_STATUS" ]; then
        /usr/bin/xrandr --output eDP-1 --primary --mode 1680x944_custom --scale 1x1 --off --output HDMI-1 --auto
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to HDMI"
        STATE=4
    elif [ "connected" == "$VGA_STATUS" ]; then
        /usr/bin/xrandr --output VGA-1 --off --output VGA-1 --auto
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to VGA"
        STATE=4
    fi
    ;;
    4)
    echo 'On state 4'
    # eDP is on, projectors are mirroring
    if [ "connected" == "$HDMI_STATUS" ]; then
        /usr/bin/xrandr --output eDP-1 --primary --mode 1680x944_custom --scale 1x1 --auto --output HDMI-1 --auto
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to HDMI mirroring"
        STATE=5
    elif [ "connected" == "$VGA_STATUS" ]; then
        /usr/bin/xrandr --output VGA-1 --auto --output VGA-1 --auto
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to VGA mirroring"
        STATE=5
    fi
    ;;
    5)
    echo 'On state 5'
    # eDP is on, projectors are extending
    if [ "connected" == "$HDMI_STATUS" ]; then
        /usr/bin/xrandr --output eDP-1 --primary --mode 1680x944_custom --scale 1x1 --auto --output HDMI-1 --auto --left-of eDP-1
        TYPE="HDMI"
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to HDMI extending"
        STATE=2
    elif [ "connected" == "$VGA_STATUS" ]; then
        /usr/bin/xrandr --output VGA-1 --auto --output VGA-1 --auto --left-of eDP-1
        TYPE="VGA"
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to VGA extending"
        STATE=2

    fi
    ;;
    *)
    echo 'On state *'
    # Unknown state, assume we're in 1
    STATE=1
esac

echo "New state is $STATE"
echo $STATE > /tmp/monitor
