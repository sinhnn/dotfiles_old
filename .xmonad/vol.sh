#!/bin/bash
#while [[ 1 ]]; do
	#statements
	vol=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($5 == "off") { print "MM" } else { print $2}}' | head -n 1)
	echo " Vol:$vol"
#	sleep 1
#done

