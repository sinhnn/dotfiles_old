#!/bin/bash
VIM_DRI=$(shell readlink -f .)
all:
	mkdir -p ~/.vim/
	cp -r ${VIM_DRI}/header ~/.vim/
	cp -r ${VIM_DRI}/snippets ~/.vim/
	#install pathogen
	mkdir -p ~/.vim/autoload ~/.vim/bundle && \
		curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
	#install vim-plugin
	cd ~/.vim/bundle; \
	git clone https://github.com/Raimondi/delimitMate.git; \
	git clone git://github.com/nachumk/systemverilog.vim; \
	git clone https://github.com/tpope/vim-surround.git; \
	git clone https://github.com/scrooloose/nerdtree.git; \
	git clone https://github.com/godlygeek/tabular.git; \
	git clone https://github.com/tomtom/tlib_vim.git; \
	git clone https://github.com/MarcWeber/vim-addon-mw-utils.git; \
	git clone https://github.com/garbas/vim-snipmate.git; \
	git clone https://github.com/honza/vim-snippets.git; \
	git clone https://github.com/vim-scripts/taglist.vim.git; \
	git clone https://github.com/vim-airline/vim-airline.git;
	#git clone https://github.com/vim-syntastic/syntastic.git; \


