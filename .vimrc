" -------------------- Common -------------------------------------------
set t_Co=256
syntax on
let g:solarized_termcolors=256
"colorscheme solarized
set background=dark
colorscheme PaperColor "default
set showmode
set autoread
set showmatch
set autoindent
set smartindent
set smarttab
"set nohlsearch
set incsearch
set showcmd
set wildmenu
set cmdheight=2
set undolevels=100
set history=1000
set tabstop=4
set shiftwidth=4
set nofoldenable

" ---------- Developer --------------------------------------------------
set textwidth=80
set tags+=build/tags,../tags,tags
set laststatus=1
set makeef=./errors.err

"Avoid invisible hi Search at cursor
hi Search term=reverse ctermfg=None ctermbg=242 guibg=DarkGrey
set statusline+=%#warningmsg#
set statusline+=%*
set fo+=c fo+=r fo-=o
" -------------------- Shortcuts --------------------
map <F3> :NERDTreeToggle<CR>
map <F4> :TagbarToggle<CR>
nnoremap <F5> :make<bar>cw<CR><CR><CR>
map <C-S-n> :silent !xterm&<CR><CR>
map <C-e> :silent cnext <CR><CR>
let g:UltiSnipsListSnippets="<c-u>"



" -------------------- Pathogen --------------------
let NERDTreeIgnore=['\~$', '^\.git', '\.swp$','\.o']
" Extra snippets
"let g:UltiSnipsSnippetsDir="~/.vim/bundle/vim-snippets/snippets/"
let g:UltiSnipsSnippetsDir="~/.vim/bundle/vim-snippets/snippets/"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "vim-snippets"]
let g:UltiSnipsEditSplit="vertical"
let g:snips_author='Ngoc-Sinh Nguyen'
let g:DoxygenToolkit_authorName=g:snips_author
let g:DoxygenToolkit_briefTag_pre="\\brief  "
let g:DoxygenToolkit_paramTag_pre="\\param "
let g:DoxygenToolkit_returnTag="\\returns   "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="--------------------------------------------------------------------------"
let g:tagbar_left = 1

execute pathogen#infect()
execute pathogen#helptags()
filetype on
filetype plugin indent on



" -------------------- Make, Error format setup -------------------------------
" CPP
function! CCPP()
	"autocmd BufWritePre,BufRead *.{cpp,c} :silent !${HOME}/.vim/gentags.sh %&
	if !filereadable("Makefile")
		if (&ft=='c')
			setlocal makeprg=gcc\ \-c\ -o\ %.o\ %\ $*
		elseif (&ft=='cpp')
			setlocal makeprg=g++\ -c\ -o\ %.o\ %\ $*
		endif
	endif
endfunction
au FileType {cpp,c} call CCPP()
" VHDL
function! VHDL()
	setlocal comments=:--
	setlocal errorformat=\*\*\ %trror:\ %f(%l):\ %m
	setlocal errorformat+=\*\*\ %tarning:\ %f(%l):\ %m
	let g:tlist_vhdl_settings='vhdl;d:package declarations;b:package bodies;
				\e:entities;a:architecture specifications;
				\T:type declarations;p:processes;
				\f:functions;r:procedures'
	if !filereadable("Makefile")
		if (&ft=='verilog')
			setlocal makeprg=vlog\ %\ $*
		elseif (&ft=='systemverilog')
			setlocal makeprg=vlog\ -sv\ %\ $*
		elseif (&ft=='vhdl')
			setlocal makeprg=vcom\ %\ $*
		endif
	endif
	execute '!ctags ' . ''
endfunction
au FileType {vhdl,verliog,systemverilog} call VHDL()
" TEX
let g:tex_flavor = "latex" " All .tex is latex file
au FileType bib setlocal ft=tex
au FileType bib setlocal syntax=bib
function! TEX()
	setlocal spell spelllang=en_us
	setlocal comments=:%
	setlocal fo+=cr fo-=o
	setlocal errorformat=%f:%l:\ %m
	setlocal fde=getline(v:lnum)=
		\~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
	let g:tlist_tex_settings = 'latex;s:Sections;l:Labels;
				\r:Refs;m:Marks;b:Bibs'

	if !filereadable("Makefile")
		setlocal makeprg=env\ max_print_line=1000\ 
					\pdflatex\ -synctex=1\ -interaction=nonstopmode\ 
					\\-file\-line\-error\ 
					\--output-dir=build\ $*\ 
					\\\\|\ vim\-error\-filter
	endif
	set errorformat=%f:%l:\ %m
endfunction
au FileType {tex,bib} call TEX()


" -------------------- Auto insert header -------------------------------
function Insertheader ()
	"If file exist, copy skeletop
	let s:fn=expand('%:t')
	let sftf = $HOME . "/.vim/header/" . s:fn
	if filereadable( sftf )
		execute '0r ' . sftf
		g/StartHere/s/StartHere//g
		startinsert
	else
		" If only extension exist.
		let sftf = $HOME . "/.vim/header/_." . &filetype
		if filereadable( sftf )
			execute '0r ' . sftf
			$
			startinsert
		endif
	endif
endfunction
autocmd bufnewfile * call Insertheader ()

" -------------------- Doxygen ------------------------------------------
" Update file name, date modified  function
function! UpdateDF()
  :mark l
  :silent! %s/!!DATE/\=  strftime("%c")/g
  :silent! %s/!!FILE/\=  expand("%")/g
  :silent! %s/File name.*/\='File name      : ' . expand("%")/g
  :silent! %s/Last modified.*/\='Last modified  : '.strftime("%c")/g
  :'l
  :delmarks l
endfunction
command UpdateDF call UpdateDF()

" ------------------------ Check Coding Style ---------------------------
highlight ColorColumn ctermbg=Black ctermfg=DarkRed
highlight ExtraWhitespace ctermbg=red guibg=red
"Check style while writting
function CheckStyle()
	set colorcolumn=+1
	match ExtraWhitespace /\s\+$/
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
endfunction
" Check style before public
function BeforePublic()
	match ExtraWhitespace /\s\+$\|^\t\+\|!!FILE\|!!DATE\|\* Desc\s*:$/
	autocmd BufWinLeave * call clearmatches()
endfunction
" Uncheck style
function UnCheckStyle()
	set cc=
	highlight clear ExtraWhitespace
endfunction
command CheckStyle call CheckStyle()
command UnCheckStyle call UnCheckStyle()
au FileType {cpp,c,make,sh,vhdl,verilog,systemverilog,tex} call CheckStyle ()
" -----------------------------------------------------------------------

" Quit Buffer when quit file
au BufEnter * call MyLastWindow()
function! MyLastWindow()
	if &buftype=="quickfix" || &buftype=="nofile"
		if winbufnr(2) == -1
			quit!
		endif
	endif
endfunction
