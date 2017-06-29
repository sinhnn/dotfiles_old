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
IFS=$'\n'
pins=($(echo "$entity_to_component" | grep --ignore-case -e ":[\t ]*in "))
pouts=($(echo "$entity_to_component" | grep --ignore-case -e ":[\t ]*out "))

# ---------- Signal declaration
for (( i = 0; i < ${#pins[*]}; i++ )); do
	echo "${pins[$i]}" | sed 's/^[\t ]*//g;
				s/^/\tsignal s_/g;
				s/:[\t ]*in[\t ]*/: /Ig;
				s/$/;/g;
				s/;;$/;/g'
done
for (( i = 0; i < ${#pouts[*]}; i++ )); do
	echo "${pouts[$i]}" | sed 's/^[\t ]*//g;
				s/^/\tsignal s_/g;
				s/:[\t ]*out[\t ]*/: /Ig;
				s/$/;/g;
				s/;;$/;/g'
done

