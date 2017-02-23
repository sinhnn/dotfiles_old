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

cmd="drive-google push -no-prompt"
dir=$(readlink -f "${PWD}")

if [[ !  ${dir} = *"Grive"* ]]; then
	dir=$(zenity --file-selection --directory --filename=${GRIVE_DIR}/)
	[ -z "${dir}" ] && { zenity -error --text="Choose google drive directory"; }
	cp -r "$@" "${dir}"
	cd ${dir}
	for args;
	do
		${cmd} $(basename "${args}")
	done
	notify-send "Google drive sendto ${dir}"
else
	${cmd} "$@"
	notify-send "Google drive sendto $@"
fi
