################################################################################
# Project name   :
# File name      : gdrive.sh
# Created date   : Sat 19 Nov 2016 08:43:23 AM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Tue 10 Jan 2017 12:41:01 PM ICT
# Guide          :
###############################################################################
#!/bin/bash

[ -z "${GRIVE_DIR}" ] && { zenity --error --text "Need to set env GRIVE_DIR to your local google drive directory" ; exit 1; }

grive_cmd="rclone -v --drive-use-trash copy"
dir=$(readlink -f ${PWD})
for args;
do
	dir=${dir}/"${args}"
	if [[ ! ${dir} == *"Grive"* ]]; then
		zenity --error --text "Choose google file or directory"
		exit 1;
	fi
	gdrive_dir=${dir#*Grive}


	if [[ -d "${dir}" ]]; then
		${grive_cmd} gdrive:"${gdrive_dir}" "${dir}"
	else

		${grive_cmd} gdrive:"${gdrive_dir}" "$(dirname "${dir}")"
	fi


	notify-send "Downloaded ${gdrive_dir}"
done


#${HOME}/.local/bin/rclone --drive-use-trash --update copy gdrive: ${GRIVE_DIR} > /dev/null 2>&1
#notify-send "Google Driver is updated"
#/home/sislab/.local/bin/rclone --drive-use-trash --update copy /media/DATA/Grive gdrive: > /dev/null 2>&1
