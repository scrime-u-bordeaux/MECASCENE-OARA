#!/bin/sh
xrandr \
  --output eDP-1    --mode 1920x1080 --rate 60 --pos 1920x1080 --rotate normal --primary \
  --output DP-1-1   --mode 1920x1080 --rate 60 --pos 0x0       --rotate normal \
  --output DP-2     --mode 1920x1080 --rate 60 --pos 1920x0    --rotate normal \
  --output HDMI-1-0 --mode 1920x1080 --rate 60 --pos 3840x0    --rotate normal

#  \
#  --output HDMI-1 --off \
#  --output DP-2   --off \
#  --output HDMI-2 --off \
#  --output DP-1-0 --off \
#
