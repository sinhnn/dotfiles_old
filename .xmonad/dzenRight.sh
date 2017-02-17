################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash
conky | dzen2 -p -x  $( echo `expr $(xrandr --current | grep -o "current.*," | grep -o "[0-9]*" | head --lines=1) \* 70 / 100`) -h '18' -ta 'r' -y '0'
