################################################################################
# Project name   : Run common playlist in chiasenhac.vn
# File name      : csh.sh
# Created date   : Fri 09 Dec 2016 12:40:57 PM ICT
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Fri 09 Dec 2016 01:58:21 PM ICT
# Guide          : Use it in an empty forder
###############################################################################
#!/bin/bash
#PLAYER=/storage/bin/play_media.sh
function play_media(){
	#kodi-send --action="PlayMedia(${abs})"
	mplayer -playlist "$@" &
	grep "chiasenhac" "$@" > $@.txt
	wget -P ${HOME}/Musics/ -i $@.txt
}

function get_link() {
	echo $(echo "$@" | sed -n 's/.*href="\([^"]*\).*/\1/p')
}

PLAYLIST=${HOME}/Musics/chiasenhac_${1}.m3u

link=""
if [[ "$1" = "vn" ]]
then
	link="http://chiasenhac.vn/mp3/vietnam/"

else
	link="http://chiasenhac.vn/mp3/us-uk/"
fi

#rm -f *.html*
tmp=$(wget -q ${link} && grep "Nghe playlist" index.html && rm -f index*)
link=$(get_link ${tmp})
#Get link playlist
wget -q "${link}"
grep -o "href.*download.html\" title" *.html > playlist.txt

rm -f *.html

echo -e "#EXTM3U \n" > playlist.m3u
while read l
do
	link=$(get_link ${l})
	echo $link
	tmp=$(wget -q ${link} &&  grep -o "href=.*data.*.mp3" *.html | tail -n 1)
	link=$(get_link "${tmp}")

	echo "EXTINF" >> ${PLAYLIST}
	echo "${link}" >> ${PLAYLIST}
	rm -f *.html

done < playlist.txt

rm -f playlist.txt
play_media ${PLAYLIST}
