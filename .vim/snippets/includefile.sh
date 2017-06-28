################################################################################
# Project name   :
# File name      : tex_fig.sh
# Created date   : Thu 16 Mar 2017 04:59:42 PM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Thu 16 Mar 2017 04:59:42 PM ICT
# Guide          :
###############################################################################
#!/bin/bash


function select_file() {
	files=$(zenity --file-selection  --separator='|'  --multiple --filename="${PWD}/" \
		--file-filter="$@" 2> /dev/null)
	files=${files//${PWD}\/}
	echo ${files}
}

function include_figure() {
	ext="*.JPG *.jpg *.png *.PNG *.pdf *.PDF"
	imgs=$(select_file "${ext}")
	[[ ${imgs//\s/ } ]] || { exit 1; }
	numb=`expr $(grep -o "|" <<< "${imgs}" | wc -l) + 1`
	if [[ $numb -gt 1 ]]; then
		scale=$( bc -l <<< 'scale=1; 1/'$numb'')
		scale="\\def\sscale{${scale}\linewidth}"
		file=${imgs%%|*}
		dir=$(dirname "$file")
		echo "\graphicspath{{"\"${dir}/\""}}"
		imgs=${imgs//"${dir}/"}
		echo "${scale}"
		while [[ ${#imgs} -gt 1   ]]
		do
			file=${imgs%%|*}
			imgs=${imgs:${#file} + 1}
			file=${file%.*}
			echo "\includegraphics[width=\sscale]{\"${file}\"}"
		done
	else
		file=${imgs}
		file=${file%.*}
		echo "\includegraphics[width=1\linewidth]{\"${file}\"}"
	fi
	# Caption and label from the last file
	file=$(basename "${file}")
	file=${file//_/ }
	# upper first word
	file=$(echo $file | sed  's/^\(.\)/\U\1/')
	echo "\caption{$file}"
	echo "\label{fig:$file}"
	# first chars of first 5 words
	#label=$(echo "${file}" | sed 's/\(.\)[^ ]* */\1/g' | cut -b 1-5 | sed -e "s/\b\(.\)/\l\1/g")
	#echo "\label{fig:$label}"

}

function include_cpp() {
	ext="*.h *.hpp *.c *.cpp"
	files=$(select_file "$ext")
	[[ ${files//\s/ } ]] || { exit 1; }
	files=$(echo "$files" | xargs -d '|' -I if echo -e "#include \"if\"" )
	files=${files//$'\n'\"/\"}
	echo "$files"
}

function include_file() {
	files=$(select_file "*")
	[[ ${files//\s/ } ]] || { exit 1; }
	files=$(echo "$files" | xargs -d '|' -I if echo -e "if" )
	files=${files//$'\n'\"/\"}
	echo "$files"

}

ext=${@##*.}
case $ext in
	tex)
		include_figure
		;;
	"c" | "cpp" | "h" | "hpp")
		include_cpp
		;;
	*)
		include_file
		;;
esac

