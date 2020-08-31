scriptencoding utf-8
set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin indent on     "Make indent code based on the file type
syntax on
"set background=light
highlight Comment    ctermfg=119
highlight clear SpellBad 
highlight SpellBad  cterm=bold ctermbg=9 gui=undercurl guisp=Yellow
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin  'VundleVim/Vundle.vim'
Plugin  'vim-airline/vim-airline'
Plugin  'vim-airline/vim-airline-themes'
Plugin  'airblade/vim-gitgutter'
"Plugin  'vimwiki/vimwiki'
Plugin 'dstein64/vim-startuptime'
Plugin  'vifm/vifm.vim'
Plugin  'jamessan/vim-gnupg'
Plugin 'AutoComplPop'
Plugin 'majutsushi/tagbar'
Plugin 'gregsexton/gitv'
Plugin 'vim-latex/vim-latex'
Plugin 'ying17zi/vim-live-latex-preview'
Plugin 'itchyny/calendar.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin  'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin  'git://git.wincent.com/command-t.git'
Plugin  'tyru/open-browser.vim'
" git repos on your local machine (i.e. when working on your own plugin)
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin  'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
"Plugin  'scrooloose/nerdtree'
Plugin 'preservim/nerdtree'
Plugin  'Xuyuanp/nerdtree-git-plugin'
Plugin  'bash-support.vim'
Plugin  'sudo.vim'
Plugin 'vim-scripts/indentpython.vim'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set laststatus=2
set showcmd
set binary
set noeol
set ttyfast
set wildmenu
set wildmode=longest,full
"set noautoindent 
set spell spelllang=en
"nnoremap \\ :noh<return>
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
let python_highlight_all=1
"vim startup time measure
let g:startuptime_sort = 0
let g:startuptime_tries = 5
let g:startuptime_exe_args = ['-u', '~/.vimrc']
"let loaded_vifm=1
"map<Leader>vv :vifm<CR>
let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.wiki\)\='

"vimwiki header colors
hi VimwikiHeader1 guifg=#FF0000
hi VimwikiHeader2 guifg=#00FF00
hi VimwikiHeader3 guifg=#0000FF
hi VimwikiHeader4 guifg=#FF00FF
hi VimwikiHeader5 guifg=#00FFFF
hi VimwikiHeader6 guifg=#FFFF00

"Show paste mode on off for text/code pasting from clipboard

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

"Pop up commit messages of the specific line of code
nmap <silent><Leader>g :call setbufvar(winbufnr(popup_atcursor(split(system("git log -n 1 -L " . line(".") . ",+1:" . expand("%:p")), "\n"), { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")<CR>

"Make leading and trailing space visible

syn match ErrorLeadSpace /^ \+/         " highlight any leading spaces
syn match ErrorTailSpace / \+$/         " highlight any trailing spaces
"match Error80            /\%>80v.\+/    " highlight anything past 80 in red

"All about indenting

set autoindent smartindent              " turn on auto/smart indenting
set smarttab                            " make <tab> and <backspace> smarter
set backspace=eol,start,indent          " allow backspacing over indent, eol, & start

"All about Tabs and Spaces 

set noexpandtab                         " use tabs, not spaces
set tabstop=8                           " tabstops of 8
set shiftwidth=8                        " indents of 8
set textwidth=78                        " screen in 80 columns wide, wrap at 78

"Tagbar to work

nmap <F8> :TagbarToggle<CR>

"NerdTree open CTRL+n

map <C-n> :NERDTreeToggle<CR>

 
"Open URI under cursor.
nmap ob <Plug>(openbrowser-open)
"Open selected URI.
vmap os <Plug>(openbrowser-open) 

"Comment out the shell script with a key stroke , which is forward slash c
"like this \c
:autocmd FileType *  nnoremap <buffer> <localleader>c I#<esc>

"Spell checking mapped with key F6
map <F6> :setlocal spell! <CR>

"Google calendar process 

let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
let g:calendar_google_event = 1
let g:calendar_event_start_time= 1
"let g:calendar_frame = 'default'
source ~/.cache/calendar.vim/credentials.vim

"Auto command for configuration file modification/change notification
augroup configfilealert
"au!
autocmd BufWritePost .bashrc !notify_config_file_updates
autocmd BufWritePost .vimrc !notify_config_file_updates
autocmd BufWritePost .gitconfig !notify_config_file_updates
autocmd BufWritePost .muttrc !notify_config_file_updates
autocmd BufWritePost .profile !notify_config_file_updates
autocmd BufWritePost .i3config !notify_config_file_updates
augroup END

" move between splits
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

"Open this file in vertical split for quick reference

nnoremap <leader>vr :vsplit ~/.vimrc<cr>

"After editing this file must be sourced ,so the changes take effect on
"current session

nnoremap <leader>sv :source ~/.vimrc<cr>

"To insert email address with a shortcut @@ ,and then need to press space after that

iabbrev @@    unixbhaskar@gmail.com

