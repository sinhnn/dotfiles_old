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

## ---------- Start
cat ~/.vim/header/_.vhdl
echo ""
grep --ignore-case "^library"  "${inf}"
grep --ignore-case "^use"  "${inf}"
echo ""
echo "entity tb_${entity} is"
echo "end entity tb_${entity};"
echo ""

echo "architecture tb_${entity}_impl of tb_${entity} is"
echo -e "$entity_to_component" | sed 's/^/\t/g'
# ---------- Signal declaration

vhdl_entity_to_signal.sh $@
echo "begin"
vhdl_entity_to_dut.sh "$@" | sed 's/^/    /g'

vhdl_entity_to_readio.sh $@ | sed 's/^/    /g'
echo "end architecture tb_${entity}_impl;"

