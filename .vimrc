" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"filetype plugin indent on

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"                                                                                                                                                    
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible        " Use Vim defaults (much better!)
set bs=indent,eol,start         " allow backspacing over everything in insert mode
"set ai                 " always set autoindenting on
"set backup             " keep a backup file
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
                        " than 50 lines of registers
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=^[[4%dm
     set t_Sf=^[[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"


set tabpagemax=15

let mapleader = ","
nnoremap <tab> :tabn<CR>
nnoremap <leader>bd :tabc<CR>
nnoremap <leader>bc :tabo<CR>

" disply number of tabs
if exists("+showtabline")
	function MyTabLine()
	    let s = ''
	    let t = tabpagenr()
		let i = 1
	    while i <= tabpagenr('$')
	        let buflist = tabpagebuflist(i)
	    let winnr = tabpagewinnr(i)
	         let s .= '%' . i . 'T'
	         let s .= (i == t ? '%1*' : '%2*')
	         let s .= ' '
	         let s .= i . ')'
	         let s .= '%*'
	         let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#' )
	     let file = bufname(buflist[winnr - 1])
	         let file = fnamemodify(file, ':p:t')
	         if file == ''
	             let file = '[NEW]'
	         else
	             let m = 0       " &modified counter
	             let bc = len(tabpagebuflist(i))     "counter to avoid last ' '
	             " loop through each buffer in a tab
	         for b in tabpagebuflist(i)
	                 " check and ++ tab's &modified count
	                 if getbufvar( b, "&modified" )
	                     let m += 1
	                     break
	                 endif
	             endfor
	             " add modified label + where n pages in tab are modified
	             if m > 0
	                 let file = '+ '.file
	             endif
	         endif
	         let s .= ' '.file.' '
	         let i = i + 1
	     endwhile
	     let s .= '%T%#TabLineFill#%='
	     let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
	     return s
	endfunction
     set stal=2
	 set tabline=%!MyTabLine()
 endif

function TabPos_ActivateBuffer(num)
	let s:count = a:num
	exe "tabfirst"
	exe "tabnext"  s:count
endfunction
			          
function  TabPos_Initialize()  
	for i in  range(1, 9)
		exe  "map <leader>"  . i .  " :call TabPos_ActivateBuffer(" . i .  ")<CR>"
	endfor
	exe  "map <leader>0 :call TabPos_ActivateBuffer(10)<CR>"
endfunction
										  
autocmd VimEnter * call TabPos_Initialize()


vnoremap <C-y> "+y
nnoremap <C-p> "+p

set cul
set number
set relativenumber
set showtabline=2
