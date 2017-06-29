################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash


#input signal
IFS=$'\n'

tmp=$(vhdl_entity_to_component.sh "$@")

entity_to_component=$(echo "$tmp" | awk 'begin{ignorecase=1};/^[\t ]*port/,0')

rins=$(echo "${entity_to_component}" \
    | grep --ignore-case -e ":\s*in\s*" \
    | sed '/^\s*--/d' \
    | sed 's/^\s*//g' \
    | cut -f1 -d " " \
    | sed 's/^/        read(iline, v_/g;s/$/); read(iline,aSpace);/g'
    )

wire_ins=$(echo "${entity_to_component}" \
    | grep --ignore-case -e ":\s*in\s*" \
    | sed '/^\s*--/d' \
    | sed 's/^\s*//g' \
    | cut -f1 -d " " \
    | sed 's/.*/        & <= v_&;/g'
    )



wous=$(echo "${entity_to_component}" \
    | grep --ignore-case -e ":\s*out\s*" \
    | sed '/^\s*--/d' \
    | sed 's/^\s*//g' \
    | cut -f1 -d " " \
    | sed 's/^/        read(iline, v_/g;s/$/); read(iline,aSpace);/g'
    )


echo -e "
READIO : process
    variable iline : inline;
    variable oline : inline;
    variable aSpace : character;
$(echo "${entity_to_component}" \
	| grep -i -e ":\s*in\s*" \
	| sed '/^\s*--/d' \
	| sed 's/^\s*/    variable v_/g;s/ in / /g;s/$/;/g;s/;;$/;/g'
)
$(echo "${entity_to_component}" \
	| grep -i -e ":\s*in\s*" \
	| grep -i -e ":\*out\*s" \
	| sed 's/^\s*/    variable v_/g;s/ in / /g;s/$/;/g;s/;;$/;/g'
)
    file inf : text;
    file ouf : text;
begin
    file_open(inf, "inf.txt",read_mode);
    file_open(inf, "ouf.txt",write_mode);

    while not endfile(inf) loop
        readline(inf,iline);
${rins[*]}
        -- Variable to signal
${wire_ins[*]}
        -- Wait for next input
        wait for TIME;
        -- Write odata
${wous[*]}
        writeline(ouf,oline);
    end loop;
    file_close(inf);
    file_open(ouf);
end process READIO;
"
