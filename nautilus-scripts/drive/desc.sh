################################################################################
# Project name   :
# File name      : sendto location.sh
# Created date   : Wed 16 Nov 2016 05:16:59 PM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Tue 10 Jan 2017 12:51:30 PM ICT
# Guide          :
###############################################################################
#!/bin/bash
command -v drive-google > /dev/null 2>&1 || {zenity -error --text="Please install drive-google"}
if [[ $# -gt 0 ]]; then

	cmd="drive-google edit-desc -description "
	dir=$(readlink -f "${PWD}")
	cmt=$(zenity --text="Description for $1" --title="Description for $1" --entry)
	${cmd} "${cmt}" "$@"
	notify-send "$cmd $cmt"

else
	notify-send "Choose file/directory"

fi

#dir="${dir[@]#*Grive}"
#for args
#do
#	if [[ -d ${args} ]]; then
#		${grive_cmd} "${args}" gdrive:"${dir}/$(basename ${args})"
#		notify-send "Sent ${args} to Grive:${dir}/$(basename ${args})"
#	else
#		rclone -v --drive-use-trash --update copy "${args}" gdrive:"${dir}"/
#		notify-send "Sent ${args} to Grive:${dir[@]}/"
#
#	fi
#done
#fi


