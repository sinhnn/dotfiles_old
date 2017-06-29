################################################################################
# Project name   : Generate skenetop for an entity
# File name      : .local/bin/vhdl_tb.sh
# Created date   : Thu 13 Apr 2017 03:08:16 PM +07
# Author         : Ngoc-Sinh Nguyen
# Last modified  : Thu 13 Apr 2017 03:08:16 PM +07
# Guide          :
###############################################################################
#!/bin/bash
inf=$@
# Entity declare
entity_to_component="$(vhdl_entity_to_component.sh $@)"
entity=$(echo "$entity_to_component" | head --lines=1 | awk '{print $2}')
IFS=$'\n'
dut=$(echo "${entity_to_component}" | \
	sed 's/component//Ig;
		s/is//Ig;
		s/^[\t ]*end.*;//Ig;
		s/port/port map/Ig;
		s/generic/genereic map/Ig;
		s/:.*;/=> ,/g;
		s/:.*/=> /g;
		s/.*=>/&&/g;
		s/=> ,/,/g;
		s/=>\s\+$//g;
		s/=>[\t ]*/=> s_/g
                /=>/s/^[\t ]*/        /g;
                /port map/s/^[\t ]*/    /Ig;
		/^[\t ]*);/s/^[\t ]*/    /g' \
	| sed ':a;N;$!ba;s/\s*);[\n]    port map/\n    )\n    port map/g' #generic map()
	)
echo -e "DUT_${entity}:$dut"

