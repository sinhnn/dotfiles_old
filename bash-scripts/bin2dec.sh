################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash


[[ $# != 2 ]] && { echo "$0 bitlength infile"; exit 1; }
bitlength=$1
while read l
do
	nl=""
	for i in $l
	do
		vl=$(echo "ibase=2;$i" | bc)
		vl=$(printf "%0${bitlength}d" $vl)
		nl="$nl $vl"
	done
	echo $nl

done < $2
