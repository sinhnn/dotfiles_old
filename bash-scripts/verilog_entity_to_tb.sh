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

cat ~/.vim/header/_.systemverilog
echo "\`include \"${entity}\""
echo -e "\n"
echo "module tb_${entity}()"
echo -e "\n"
verilog_entity_to_dut.sh $@ | sed 's/^/    /g'
echo -e "\n"
echo -e "    /* -------------------------------------------------------- */"
echo -e "    initial begin"
echo -e "\n\n        \$finish;"
echo -e "    end"
echo "enmodule"
