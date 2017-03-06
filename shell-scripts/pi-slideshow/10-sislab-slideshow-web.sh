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
[ command -v midori > /dev/null 2>&1 ] || apt-get install -y feh

#HTML
xset -dpms     # disable DPMS (Energy Star) features.
xset s off       # disable screen saver
xset s noblank # don't blank the video device
unclutter &
matchbox-window-manager &
#shutdown key be refresh
# xev to key keycode
# xmodmap -pke to show keymap
xmodmap -d :0.0 -e "keycode 124 = F5 F5 F5 F5 F5 F5 XF86PowerOff"
midori -e Fullscreen -e enable-javascript=true -a http://10.10.128.6/sislab-slideshow/
