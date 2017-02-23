################################################################################
# Project name   : 
# File name      : github/linux-configurations/nautilus-scripts/sendto email.sh
# Created date   : Wed 26 Oct 2016 01:51:51 PM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Tue 20 Dec 2016 04:09:49 PM ICT
# Guide          : 
###############################################################################
#!/bin/bash


#BUG: no support space in file path

# Check input: --noconfirm 

e="" #email address
s="" #subject
at=() #attachs
atm=()
b="" #$(cat ${HOME}/github/linux-configurations/auto_email.txt)  #body
c="" #confirm or not
#default subject
ds=""

# ZIp and return outfile
function zip_dir() {
        #function_body
        dir=$(readlink -f "$@")
        bs=$(basename "$@")
        cd "${dir[@]}"/..
        zip -qr "${bs[@]}".zip "${bs[@]}"
        cd - > /dev/null
        sleep 1
        echo "${bs[@]}.zip"
}
function cus_zip_dir() {
	dir=$(readlink -f "$@")
	if [[ -d ${dir[@]} ]]; then
		bs=$(zip_dir "${dir[@]}") && mv "${bs[@]}" /tmp && dir=/tmp/"${bs[@]}"
	fi
	echo "${dir[@]}"
}

while getopts ":e:s:a:b:c" o;
do
	case $o in
		e) 
			e=(${e[@]} \"${OPTARG}\");;
		s) 
			s=${OPTARG};;
		b)
			b=${OPTARG};;
		c)
			c="noconfirm";;
		a)
			#thunder
			ds=$(basename "${OPTARG}")
			f=$(cus_zip_dir "${OPTARG}")
			#f=",file://${f}"
			at=("${at[@]}" ",file://${f}")
			#mailx
			atm=(${atm[@]} "-a \"${f}\"");;
		*)
			notify-send "Unsupported option";
			exit 1;;
	esac
done

opt="${b}${e}${s}${at}"

# For nautilus -> no option
if [[ ! ${opt// /}  ]]; then
	#  NO option -> all is attachment
	for args
	do
		ds=$(basename "${args}")
		f=$(cus_zip_dir "${args}")
		f=",file://${f[@]}"
		at=("${at[@]}" "${f[@]}")
	done
fi

if [[ ! ${s// /} ]]; then
	s="[Send File] ${ds[@]}"
fi

if [[ ! ${e[@]} ]]; then
	e=$(echo ${COMM_MAIL})
fi


function send_by_thunderbird() {
	#function_body
	at=${at[@]}
	if [[ ! ${b} ]]; then
		#statements
		b=$(cat ${HOME}/github/linux-configurations/auto_email.txt)  #body
	fi
	#echo "thunderbird --compose \"subject='$s',attachment='${at:1}',body='$b',to='${to}'\""
	thunderbird --compose "subject='$s',attachment='${at:1}',body='$b',to='${e[@]}'"
}


function send_by_mailx() {
	if [[ ! ${b} ]]; then
		b="cat ${HOME}/github/linux-configurations/auto_email_mailx.txt \
			${HOME}/github/linux-configurations/email_sig.eml"
	fi
	cmd=$(echo "$b | mailx -s \"$s\" ${atm[@]} ${e[@]}")
	echo ${cmd}
	/bin/bash -c "${cmd}"
	notify-send "Sent ${atm[@]} to ${e[@]}"

}

echo ${c}

if [[ "${c}" = "noconfirm" ]]; then
	echo ${c}
	send_by_mailx
else
	send_by_thunderbird
fi



