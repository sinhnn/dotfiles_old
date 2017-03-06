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
# echo "/path/to/script/script" & >> /etc/profile

#
[[ command -v fbi > /dev/null 2>&1 ]] || apt-get install -y fbi
SLIDE_DIR=/root/sislab-slideshow/images/slides
INTERVAL=5s
fbi -noverbose -a -t ${INTERVAL} ${SLIDE_DIR}/*.jpg


