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


if [[ $# -gt 0 ]]; then
	cmd="drive-google share"

	opt=$(zenity --forms --title "Share google file" \
		--text "Share google file" \
		--add-entry "Email address" \
		--add-entry="Comment")
	emails=${opt%|*}
	cmt=${opt#*|}
	${cmd} -no-prompt -emails "${emails}" -message "${cmt}" -role -role reader,commenter "$@"
	notify-send "${cmt} -emails "${emails}" -message "${cmt}" -role reader,commenter "$@" "

else
	notify-send "Choose file/directory"
fi

