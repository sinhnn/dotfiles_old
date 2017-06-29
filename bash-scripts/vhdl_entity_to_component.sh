################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash

for file
do
	# in sed \s=[\t ]*
	if [[ ${file##*.} = "vhd" || ${file##*.} = "vhdl" ]]; then
		# get entity declare
		# line break for every ;
		# replace 'entity' by 'component'
		# delete 'is'
		# reformat "end entity"
		# reformat "trailing" at start of line
		# delete comment line
		awk 'BEGIN{IGNORECASE = 1};/^[\t ]*entity/,/^[\t ]*end[\t ].*;/' \
			"${file}" \
			| sed '/;/s/;/;\n       /g;
				s/--.*//g;
				s/^entity/component/Ig;
				s/^\s*entity/component/Ig;
				s/\s*is\s*//Ig;
				s/^\s*end\s*$/end component/Ig;
				s/^\s*end\s*entity\s*;/end component;/Ig;
				s/^\s*generic\s*(/    generic (\n        /Ig;
				s/^\s*port\s*(/    port (\n        /Ig;
				/in/Is/^\s*/        /g;
				/out/Is/^\s*/        /g;
				/^\s*port/Is/^\s*/    /g;
				/^\s*generic/Is/^\s*/    /g;
				/^\s*);/Is/^\s*/    /g;' \
			| sed ':a;N;$!ba;s/\s*)\s*;\s*\n*\s*port/\n    );\n    port/Ig' \
			| sed ':a;N;$!ba;s/\s*)\s*;\s*\n*\s*end/\n    );\nend/Ig' \
			| sed 's/^\s*component/component/g' \
			| sed '/^$/d;/^\s*$/d;'
	else # verilog or sv
		awk 'BEGIN{IGNORECASE = 1};/^[\t ]*module/,/^[\t ]*);/' \
			"${file}" \
			| sed 's/module//Ig'
	fi
done
