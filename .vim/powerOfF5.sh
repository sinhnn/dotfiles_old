################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash

f=$@
ft=${f##*.}


function compile_latex() {
	mkdir -p build
	#pdflatex -synctex=1 -file-line-error -interaction=nonstopmode "${@}" \

	f=${@%.*}
	env max_print_line=1000 pdflatex -file-line-error \
		-interaction=nonstopmode --output-dir=build \
		"${@}" > /dev/null 2>&1 ;
	bibtex build/${f}.aux
	grep "Error:" build/${f}.log > errors.err
	grep "Warning:" build/${f}.log >> errors.err
	sed -i '/\.aux/d' errors.err
	pdffile=$(readlink -f build/${f}.pdf)
	if [[ ! $(pgrep  -f "atril ${pdffile}") ]]; then
		 atril "${pdffile}"  > /dev/null 2>&1 &
	 fi

} 

function F5latex() {
	# Find root document
	dir=$(dirname $@)
	file=$(basename "$@")
	cd $( readlink -f ${dir})
	# Main files
	if [[ $(cat ${file} | grep "\\documentclass") ]]; then
		compile_latex "$file" &
	else
		grep -e "\\documentclass" *.tex | grep -o ".*\.tex" > .F5latex
		# Main file include current file
		while read l
		do
			[[ $(grep -r "${file%%.tex}" "$l" ) ]] && { \
				compile_latex "$l"; }
		done < .F5latex
		rm -f .F5latex
	fi
}


case $ft in
	"tex")
		F5latex "$f" &
		;;
	"c" | "cpp" | "h" | "hpp")
		if [[ -f Makefile ]]; then
			make 2> errors.err
		else
			mf=$(zenity --file-selection \
				--text="Choose your Makefile" \
				--filename="${PWD}/" \
				--file-filter="Makefile makefile *.sh")
			if [[ -z ${mf// } ]]; then
				notify-send "No Makefile is selected"
			else
				make -f "${mf}" 2> errors.err
			fi
		fi
		;;
	"md" | "markdown")
		#Requires markdown plugin
		firefox "$f";;
	*)
		echo "Nothing todo with this $ft"
		;;
esac
