################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash
# Install
# echo "xinit /path/to/script/script" & >> /etc/profile

### Requirements
[ command -v xset > /dev/null 2>&1 ] || apt-get install -y xorg
[ command -v unclutter > /dev/null 2>&1 ] || apt-get install -y unclutter
[ command -v matchbox-panel > /dev/null 2>&1 ] || apt-get install -y matchbox
[ command -v feh > /dev/null 2>&1 ] || apt-get install -y feh

xset -dpms     # disable DPMS (Energy Star) features.
xset s off       # disable screen saver
xset s noblank # don't blank the video device
unclutter &
matchbox-window-manager &
export DISPLAY=:0.0
#shutdown key be refresh
# xev to key keycode
# xmodmap -pke to show keymap
xmodmap -d :0.0 -e "keycode 124 = F5 F5 F5 F5 F5 F5 XF86PowerOff"
SLIDE_DIR=/root/sislab-slideshow/images/slides
INTERVAL=5s
height=$(xrandr | grep " connected" | egrep -o "[0-9]{3,4}x" | egrep -o "[0-9]{3,4}")
cmd="/usr/bin/feh --hide-pointer --bg-fill"
while [ true ]
do

	for img in ${SLIDE_DIR}/*.jpg
	do
		${cmd} ${img};
		cat ${img}.caption | dzen2 -y ${height}  -ta 'l' -p &
		sleep 10s
	done
done
