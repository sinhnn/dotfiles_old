# ------------------------------------------------------------------------------
# Project name   :
# File name      : latex_include_figs.sh
# Created date   : Thu 16 Mar 2017 04:59:42 PM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Fri 30 Jun 2017 01:20:30 PM +07
# Guide          :
# ------------------------------------------------------------------------------
#!/bin/bash

function include_figures() {

	[[  $# -eq 0 ]] &&  exit 1
	numb=$#
	scale=$( bc -l <<< 'scale=1; 1/'$numb'')
	scale="\\def\sscale{${scale}\linewidth}"
	caps=$(basename "$1")
	caps=${caps%%.*}
	echo "\begin{figure}[h]"
	echo -e "\t${scale}"
	for args
	do
		echo -e "\t\includegraphics[width=\sscale]{\"${args}\"}"
	done
	# Caption and label from the last file
	echo -e "\t\\\\caption{$caps}"
	echo -e "\t\label{fig:$caps}"
	echo "\end{figure}"
}

include_figures "$@"
