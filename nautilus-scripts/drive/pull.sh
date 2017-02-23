################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash

command -v drive-google > /dev/null 2>&1 || {zenity -error --text="Please install drive-google"}
cmd="drive-google pull -no-prompt"
${cmd} "$@"
notify-send "Google drive download $@"
