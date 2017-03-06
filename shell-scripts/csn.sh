################################################################################
# Project name   : Run common playlist in chiasenhac.vn
# File name      : csh.sh
# Created date   : Fri 09 Dec 2016 12:40:57 PM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Fri 09 Dec 2016 01:58:21 PM ICT
# Guide          : Play and download musics from chiasenhac.vn to ${HOME}/Musics/csn
###############################################################################
#!/bin/bash

function download_media() {
	#function_body
	grep "chiasenhac" "$@" > $@.txt
	wget -nc -P ${MUSIC_DIR}/ -i $@.txt
	rm -f $@.txt
}

function play_download_media(){
	#kodi-send --action="PlayMedia(${abs})"
	mplayer -playlist "$@" &
	download_media "$@"
}

function get_link() {
	echo $(echo "$@" | sed -n 's/.*href="\([^"]*\).*/\1/p')
}

function usage () {
        echo "Usage :  $0 [options] [--]
	Options:
	-h|help			Help
	-vn|--vietnam		chiasenhac.vn/mp3/vietnam
	-us|--us-uk		chiasenhac.vn/mp3/us-uk
	-dl|--download-only	download only"
}

function gen_m3u() {
	playlist_link="$1"
	outfile="$2"
	tmp=$(wget -q ${playlist_link} && grep "Nghe playlist" index.html && rm -f index*)
	mp3_link=$(get_link ${tmp})
	#Get link playlist
	wget -q "${mp3_link}"
	grep -o "href.*download.html\" title" *.html > playlist.txt
	rm -f *.html
	# GET link from html
	echo -e "#EXTM3U \n" > ${outfile}
	while read l
	do
		mp3_link=$(get_link ${l})
		echo ${mp3_link}
		tmp=$(wget -q ${mp3_link} &&  grep -o "href=.*data.*.mp3" *.html | tail -n 1)
		mp3_link=$(get_link "${tmp}")
		echo "EXTINF" >> ${outfile}
		echo "${mp3_link}" >> ${outfile}
		rm -f *.html
	done < playlist.txt
	rm -f playlist.txt
}

MUSIC_DIR="${HOME}/Musics/csn/us/"
LINK="http://chiasenhac.vn/mp3/us-uk/"
DOWNLOAD_ONLY=false

while true; do
	case "$1" in
		-h|--help ) usage; exit 1;;
		-vn|--vietnam ) LINK="http://chiasenhac.vn/mp3/vietnam/";\
			MUSIC_DIR="${HOME}/Musics/csn/vn/"; shift ;;
		-dl|--download-only ) DOWNLOAD_ONLY=true; shift ;;
		-us|--us-uk ) LINK="http://chiasenhac.vn/mp3/us-uk/";\
			MUSIC_DIR="${HOME}/Musics/csn/us/" ; shift ;;
		* ) break ;;
	esac
done
#if [[ "$1" = "vn" ]]
#then
#	link="http://chiasenhac.vn/mp3/vietnam/"
#	MUSIC_DIR=${HOME}/Musics/csn/vn/
#
#else
#	link="http://chiasenhac.vn/mp3/us-uk/"
#	MUSIC_DIR=${HOME}/Musics/csn/us/
#fi
mkdir -p ${MUSIC_DIR}
PLAYLIST=${MUSIC_DIR}/csn.m3u


# GET html data
gen_m3u ${LINK} ${PLAYLIST}
if [[ "${DOWNLOAD_ONLY}" = "true" ]]; then
	download_media ${PLAYLIST}
else
	play_download_media ${PLAYLIST}
fi
