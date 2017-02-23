################################################################################
# Project name   :
# File name      : sendto location.sh
# Created date   : Wed 16 Nov 2016 05:16:59 PM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Tue 10 Jan 2017 12:51:30 PM ICT
# Guide          :
###############################################################################
#!/bin/bash


#opts=$(yad --width=400 --height=200 \
#	--title "Send file to devices" --text "Send file to devices" \
#	--list --checklist --column="Send" --column="Devices"\
#	"True" "Google Drive"\
#	"False" "Nook Simple Touch"\
#	"False" "USB")
#
#ignore="*{~,.bak,.back,.lnk,.git}"
#
##loc="${opts%%|*}"
##opts=${opts:${#loc} + 1}
#
#function copy_to_dir() {
#	dest=${@: -1}
#        if [[ ! -d "${dest}"  && ! -e "${tmp}"  ]]; then
#		zenity --error --text "File or directory ${tmp} does dnot exits"
#	else
#		cp -r "$@" && notify-send "cp -r $@"
#	fi
#
#
#}
#
#
#if [[ ${opts} == *"Nook"* ]]; then
#	dest=$(zenity --file-selection \
#		--directory --filename='/media/NOOK/My Files/Books')
#	copy_to_dir "$@" "${dest}"
#fi
#
#if [[ ${opts} == *"USB"* ]]; then
#	dest=("${dest[@]}" \
#		"$(zenity --file-selection \
#		--directory --filename="/media/")")
#	copy_to_dir "$@" "${dest}"
#	#cp -r "$@" "${dest}" && notify-send "Copy $@ to ${dest}"
#fi

[ -z "${GRIVE_DIR}" ] && { zenity --error --text \
        "Need to set env GRIVE_DIR to your local google drive directory" ; exit
1; }

grive_cmd="rclone -v --drive-use-trash --update \
	--delete-excluded --filter-from ${HOME}/.rcloneignore --dump-filters  copy"

#if [[ ${opts} = *"Google"* ]]; then
# Get directory
#echo ${PWD}

dir=$(readlink -f "${PWD}")
if [[ ! ${dir} == *"Grive"* ]]; then
	dir=$(zenity --file-selection --directory --filename=${GRIVE_DIR}/)
	[ -z "${dir}" ]  && exit 1
	cp -r "$@" "${dir}"
fi
dir="${dir[@]#*Grive}"
for args
do
	if [[ -d ${args} ]]; then
		${grive_cmd} "${args}" gdrive:"${dir}/$(basename ${args})"
		notify-send "Sent ${args} to Grive:${dir}/$(basename ${args})"
	else
		rclone -v --drive-use-trash --update copy "${args}" gdrive:"${dir}"/
		notify-send "Sent ${args} to Grive:${dir[@]}/"

	fi
done
#fi


