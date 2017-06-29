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
entity=$(echo "$entity_to_component" | head --lines=1 | awk '{print $1}')

IFS=$'\n'

# ---------- Signal declaration

sigs=$(echo "$entity_to_component" | \
	grep --ignore-case "input\|output" | \
	sed 's/input\s*//g;
		s/output\s*//g;
		s/logic\s*/logic s_/g;
		s/]\s*/] s_/g;
		s/s_\[/\[/g;
		s/$/;/g;
		s/,;$/;/g;
		s/^\s*//g
		s/logic\s*s_/logic    [] s_/g;
		')
echo "$sigs" | column -t | sed 's/\[\]/  /g'
dut=$(echo "${entity_to_component}" | \
	sed '1 s/^\s*//Ig;
		s/^\s*)/)/Ig;
		s/\s*=\s*//Ig;
		s/^\s*parameter\s*/    \./Ig;
		/^\s*\//d;
		s/\s*input\s*logic\s*/    \./Ig;
		s/\s*output[\t ]*logic[\t ]*/    \./Ig;
		s/^\s*\.\[.*\]\s*/    \./Ig;
		/^\s*\./s/\..*/&    (s_&)/Ig;
		s/_\./_/g;
		/,\s*(/s/, / /g;
		s/,)/),/g
	')
echo "$dut" | column -t | sed 's/^\./    \./g;s/)\s*(/) a_'${entity}' (/g'

