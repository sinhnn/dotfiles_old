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

function include_bib() {
	ext=" *.pdf *.PDF"
	files=$(select_file "${ext}")
	[[ ${files//\s/ } ]] || { files="Ngoc-Sinh Nguyen"; }
	while [[ ${#files} -gt 1   ]]
	do
		file=${files%%|*}
		files=${files:${#file} + 1}
		file=$(basename "$file")
		#Get info
		title=${file%%.*}
		info=$(yad --form --width=800 --title="BIB file" --text="Bib form" \
			--item-separator="|" \
			--field="Title" \
			--field="Author" \
			--field="Booktitle" \
			--field="Publisher" \
			--field="Page" \
			--field="Month" \
			--field="Year" \
			"${title}")

		title=$(echo "${info}" | cut -d "|" -f1 )
		author=$(echo "${info}" |  cut -d "|" -f2)
		booktitle=$(echo "${info}" | cut -d "|" -f3)
		publisher=$(echo "${info}" |  cut -d "|" -f4)
		addr=$(echo "${info}" | cut -d "|" -f5)
		month=$(echo "${info}" | cut -d "|" -f6)
		year=$(echo "${info}" | cut -d "|" -f7)
		citekey=$(echo "${title}" | sed 's/\(.\)[^ ]* */\1/g' \
			| cut -b 1-5 | sed -e "s/\b\(.\)/\l\1/g")
		citekey="${citekey}`echo ${year} | cut -b 3-4`"

		echo "bib:${citekey},"
		echo -e "\tTitle\t\t\t= {${title}},"
		echo -e "\tAuthor\t\t\t= {${author}},"
		echo -e "\tBooktitle\t\t= {${booktitle}},"
		echo -e "\tPublisher\t\t= {${publisher}},"
		echo -e "\tPages\t\t\t= {${addr}},"
		echo -e "\tMonth\t\t\t= {${month}}",
		echo -e "\tYear\t\t\t= {${year}}"

	done

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
	"bib")
		include_bib
		;;

	*)
		include_file
		;;
esac

