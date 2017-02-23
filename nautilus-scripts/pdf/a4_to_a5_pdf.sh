################################################################################
# Project name   : 
# File name      : pdf/pdf_a4_a5.sh
# Created date   : Sat 26 Nov 2016 10:49:56 AM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Sat 26 Nov 2016 04:19:58 PM ICT
# Guide          : 
###############################################################################
#!/bin/bash


source ${HOME}/github/linux-configurations/scripts/check_args.sh
dest=""
title="PDF A4 to A5"

opts=$(zenity --list \
	--title="${title}" \
	--text="${title}" \
	--checklist \
	--column="" --column="Option" \
	True "A4 1 column" \
	FALSE "A4 2 columns"\
	TRUE "Send to NOOK")


exit_no_opts ${opts}

angle=90
if [[ "${opts}" == *"A4 2 column"* ]]; then
	angle=360
	window="0/0.49/0.5/0,0/0/0.5/0.49,0.5/0.5/0/0,0.5/0/0/0.49" # 1 a4 page -> 4 a5 page
	window="${window}:${window}"
	jam_opts="--scale 1 --paper a5paper \
			--angle ${angle} --rotateoversize false" 

else

	window="0/0.49/0/0,0/0/0/0.49" # a a4 page -> 2 a5 page
	#window="0/0.63/0/0,0/0.33/0/0.36,0/0/0/0.66" # a a4page -> 3 a5 page
	window="${window}:${window}"
	jam_opts="--scale 1 --paper a5paper \
			--angle ${angle} --rotateoversize false" 

fi

if [[ "${opts}" == *"NOOK"* ]]; then
	dest="/media/NOOK/My Files/Documents/"
fi
exit_no_dest "${dest}"

for args
do
	(
		echo 1
		echo "# Converting A4 to A5 ${args} "
		java -jar \
			${HOME}/github/linux-configurations/nautilus-scripts/pdf/briss-0.0.14.jar\
			-s "${args}" -d a4_to_a5.pdf -c "${window}"
		pdfjam ${jam_opts} --outfile "${dest}""${args//.pdf/_a5.pdf}" \
			-- a4_to_a5.pdf
		#rm -f a4_to_a5.pdf
		echo 100
	) | yad --title "${title}" --progress --pulsate --auto-close --no-buttons

done


