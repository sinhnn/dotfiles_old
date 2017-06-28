#!/bin/bash
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle
git init
git submodule init
git submodule add https://github.com/Raimondi/delimitMate.git 
git submodule add https://github.com/nachumk/systemverilog.vim 
git submodule add https://github.com/tpope/vim-surround.git 
git submodule add https://github.com/scrooloose/nerdtree.git 
git submodule add https://github.com/godlygeek/tabular.git 
#git submodule add https://github.com/tomtom/tlib_vim.git 
#git submodule add https://github.com/MarcWeber/vim-addon-mw-utils.git
#git submodule add https://github.com/garbas/vim-snipmate.git 
git submodule add https://github.com/honza/vim-snippets.git 
git submodule add https://github.com/vim-syntastic/syntastic.git 
#git submodule add https://github.com/vim-scripts/taglist.vim.git 
git submodule add https://github.com/vim-airline/vim-airline.git
git submodule add https://github.com/vim-scripts/Conque-GDB
git submodule add https://github.com/vim-scripts/DoxygenToolkit.vim
git submodule add https://github.com/airblade/vim-gitgutter
git submodule add https://github.com/rhysd/vim-clang-format
git submodule add https://github.com/majutsushi/tagbar
git submodule add https://github.com/SirVer/ultisnips

