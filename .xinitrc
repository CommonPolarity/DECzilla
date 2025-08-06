#!/bin/sh

if ["$1" = "backend-mode"]; then
    xfwm4 &
    exec xfce4-terminal
else
    xfwm4 &
    exec firefox --kiosk http://localhost:5000/fullscreen.html
fi