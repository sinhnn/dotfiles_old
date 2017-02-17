################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash
dzen2 -x '0' -y '0' -h '18' -w $( echo `expr $(xrandr --current | grep -o "current.*," | grep -o "[0-9]*" | head --lines=1) \* 70 / 100`) -ta 'l'



