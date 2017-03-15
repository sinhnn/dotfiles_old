################################################################################
# Project name   : Run common playlist in chiasenhac.vn
# File name      : csh.sh
# Created date   : Fri 09 Dec 2016 12:40:57 PM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Fri 09 Dec 2016 01:58:21 PM ICT
# Guide          : Play and download musics from chiasenhac.vn to ${HOME}/Musics/csn
###############################################################################
#!/bin/bash
function usage () {
        echo "Usage :  $0 [options] [--]
	Options:
	-h|help			Help
	-vn|--vietnam		chiasenhac.vn/mp3/vietnam
	-us|--us-uk		chiasenhac.vn/mp3/us-uk
	-dl|--download-only	download only"
}

# Get http link
function get_link() {
	echo $(echo "$@" | sed -n 's/.*href="\([^"]*\).*/\1/p')
}

# Gen m3u playlist from link
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
	rm ${outfile}
	touch ${outfile}
	while read l
	do
		mp3_link=$(get_link ${l})
		echo ${mp3_link}
		tmp=$(wget -q ${mp3_link} &&  grep -o "href=.*data.*.mp3" *.html | tail -n 1)
		mp3_link=$(get_link "${tmp}")
		#echo "EXTINF" >> ${outfile}
		echo "${mp3_link}" >> ${outfile}
		rm -f *.html
	done < playlist.txt
	rm -f playlist.txt
}
# Local playlist
function csn_m3u_to_local_m3u() {
	if="$1"
	of="$2"
	dir=$(dirname "$if")
	sed -e 's~http.*/~'${dir}'/~g' "$if" > "$of"
	sed -i -e 's/%20/ /g' "$of"
}
# Remove file not exist in playlist.m3u
function rm_non_exist_in_local_mp3() {
	dir=$(dirname $@)
	ls ${dir}/*.mp3 | sort > file_in_dir.txt
	sed '/EXT/d' $@ > tmp.txt
	sed -i '/^\s*$/d' tmp.txt
	sort tmp.txt > file_in_list.txt
	diff -c file_in_dir.txt file_in_list.txt > patch
	grep "^- " patch | sed 's/^- //g'> rm.txt
	[[ -s rm.txt ]] && { cat rm.txt | xargs -d '\n'  rm ;}
	rm -f file_in_dir.txt file_in_list.txt patch tmp.txt rm.txt
}

#Download only
function download_media() {
	#function_body
	grep "chiasenhac" "$@" > $@.txt
	wget -nc -P ${MUSIC_DIR}/ -i $@.txt
	rm -f $@.txt
}
# Download and play by mplayer
function play_download_media(){
	#kodi-send --action="PlayMedia(${abs})"
	mplayer -playlist "$@" &
	download_media "$@"
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
mkdir -p ${MUSIC_DIR}
PLAYLIST=${MUSIC_DIR}/csn.m3u
LOCAL_PLAYLIST=${MUSIC_DIR}/playlist.m3u


# GET html data
gen_m3u ${LINK} ${PLAYLIST}
if [[ "${DOWNLOAD_ONLY}" = "true" ]]; then
	download_media ${PLAYLIST}
else
	play_download_media ${PLAYLIST}
fi
csn_m3u_to_local_m3u ${PLAYLIST} ${LOCAL_PLAYLIST}
rm_non_exist_in_local_mp3 "${LOCAL_PLAYLIST}"
