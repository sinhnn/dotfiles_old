################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################
#!/bin/bash

if [[ ! $PRE_GITLATEX_VERSION = "" ]]; then
	#statements
	v="$PRE_GITLATEX_VERSION"
else
	v="1"
fi
f="index.tex"
update="false"
others=""

while [[ "$1" ]] ; do

	case "$1" in
		-m|--main-file ) f="$2";
			 shift 2;;
		-v|--compare-version ) v="$2"; shift 2;;
		-u|--update ) update="true"; shift ;;
		-h|--help )
            echo "$(basename $0) [main-tex-file] [compare-commit-version] [--update]"
            echo -e "    -m|--main-file             Default \"index.tex\""
            echo -e "    -v|--compare-version       Default \"HEAD~1\""
            echo -e "    -u|--update                Default \"false\""
            echo -e "    -o|--output                pdf outfile"
            exit 1
			;;
		*)
			others="$others $1"
			shift ;;
	esac
done

[[ -e "$f" ]] || { echo "No main-file $f found"; $0 --help ; exit 1; }

if [[ ! $v = *[a-Z]* ]]; then

	max=$(git log --format=%H | wc -l)
	echo "$(($max - $v))"
	if [[ $(($max - $v)) = "-"[0-9]* ]]; then
		echo "$v is greatter than current version"
		exit 1;
	fi
	v=$(git log --format=%H | tail --lines=$v | head --lines=1 )
fi

gitlatexdiff_cmd="git latexdiff \
	--verbose \
	--tmpdirprefix build/ \
	--latexopt -interaction=nonstopmode \
	--ignore-latex-errors \
	--whole-tree \
	--ignore-warnings \
	$others \
	--main "$f"\
	$v HEAD &"

if [[ ! -d  ".git" ]]; then
	echo "Generating git"
	git init
	git add -all && git commit -m "v1"
else
	mkdir -p build
	if [[ $update = "true" ]]; then
		echo "Update"
		n=$(git rev-list --all --count)
		let n++;
		git add --all
		git commit -m "v$n"
	fi
	eval $gitlatexdiff_cmd
fi

