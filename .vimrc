" -------------------- Common --------------------
set t_Co=256
set background=dark
set showmode
set autoread  "Automatically re-read file if it has changed
set showmatch "Show matching bracket when text indicator over them"
syntax on
hi Comment ctermfg=8 guifg=#808080
hi Search cterm=NONE ctermfg=grey ctermbg=blue
set autoindent " Set auto indent"
set smartindent " Set smart indent"
"set shiftwidth=4
set smarttab
set hlsearch " Hightlight search"
set incsearch "Search as morden browser"
set showcmd
set wildmenu
"set textwidth=80
set cmdheight=2 "Command height window"
set smartcase "Try smart with case when searching"
set path=.,inc,src,../inc,../src
set undolevels=100
set history=1000

" -------------------- Shortcuts --------------------
map <F3> :NERDTreeToggle<CR>
map <F4> :TlistToggle<CR>
map <F5> :!~/.vim/make_in_vim.sh %<CR>
map <F6> :SyntasticToggleMode<CR>
map <C-S-n> :silent !xterm &<CR><CR>


" -------------------- Plugins --------------------
let Tlist_WinWidth=40
let NERDTreeIgnore=['\~$', '^\.git', '\.swp$','\.o']

"let b:syntastic_cpp_cflags = '-I../inc -I./inc'
"let b:syntastic_c_cflags = '-I../inc -I./inc'
set statusline+=%#warningmsg#
"let b:syntastic_checkers=['c',"cpp","vhdl","hdl"]
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 1
"let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes':   [],'passive_filetypes': [] }
let g:tex_flavor = "latex" " All .tex is latex file

" -------------------- Pathogen --------------------
execute pathogen#infect()
execute pathogen#helptags()
filetype on
filetype plugin indent on

" -------------------- Common source file setting --------------------
"autocmd QuitPre *.{c,cpp,cxx,hpp,cc,h,v,sv,vhd,vhdl,sh,md} call UpdateDF()
"autocmd QuitPre Makefile call UpdateDF()
"autocmd QuitPre README call UpdateDF()
" Remove trailing space
"autocmd BufWritePost *.{c,cpp,h,hpp,sv,v,cxx,sh} :%s/\s\+$//e
"autocmd BufWritePost {Makefile,CMakeLists.txt} :%s/\s\+$//e
" Follow linux kernel
" 80 characters line
" +r	auto insert current comment after hitting "Enter key" in Insert mode
" +c	auto wrap cmt using textwith
" +o	Automatically insert the current comment leader after hitting 'o' or 'O'
au FileType c setlocal fo+=c fo+=r fo-=o
au FileType cpp setlocal fo+=c fo+=r fo-=o
set colorcolumn=81
"execute "set colorcolumn=" . join(range(81,335), ',')
highlight ColorColumn ctermbg=Black ctermfg=DarkRed
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
match ExtraWhitespace /\s\+$/


" -------------------- C/C++ file --------------------
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
au FileType cpp set tags+=.tags,../.tags
au FileType c set tags+=.tags,../.tags
"autocmd bufnewfile *.{c,cpp,cxx,hpp,cc,h,v,sv}  0r ~/.vim/header/headerC.txt
"autocmd bufnewfile README 0r ~/.vim/header/headerC.txt

" -------------------- VHDL file --------------------
au FileType vhdl setlocal comments=:--
au FileType vhdl setlocal fo+=c fo+=r fo-=o


" -------------------- Auto insert header --------------------
function Insertheader ()
	let sftf = $HOME . "/.vim/header/header." . &filetype
	if filereadable( sftf )
		execute '0r ' . sftf
	endif
endfunction

autocmd bufnewfile * call Insertheader ()

" -------------------- Doxygen --------------------
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
" Update doxygen
function! UpdateDoxy()
  :mark l
  "C/C++, SystemC, Verilog
  :silent! g/\\param/s/\,/\r* \\param/g
  :'l
  :delmarks l
endfunction
command UpdateDoxy call UpdateDoxy()

"Function for latex

