scriptencoding utf-8
set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin indent on     "Make indent code based on the file type
syntax on
"set background=light
highlight Comment    ctermfg=119
highlight clear SpellBad
highlight SpellBad  cterm=bold ctermbg=9 gui=undercurl guisp=Yellow

"Make the visual selection more prominent

highlight Visual term=bold cterm=bold ctermbg=7 ctermfg=2 guifg=Red guibg=LightBlue

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
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'sunaku/vim-shortcut'
Plugin 'TaDaa/vimade'
Plugin 'junegunn/gv.vim'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-unimpaired'
Plugin 'mbbill/undotree'
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
source ~/.vim/bundle/vim-shortcut/plugin/shortcut.vim

"Default bindings

set laststatus=2
set showcmd
set binary
set noeol
set ttyfast
set wildmenu
set wildmode=longest,full
set showbreak=...
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


"Shortcut! Git commit popup messages of the specific line of code
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
set softtabstop=8
set shiftwidth=8                        " indents of 8
set textwidth=78                        " screen in 80 columns wide, wrap at 78


"Shortcut! paste mode on or off
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>


"History of changes showing by undotree plugin
nnoremap <F3> :UndotreeToggle<CR>

"Showing non visible character by toggle
nmap <F4> :set list!<CR>

"Removing trailing whitespace
nnoremap <F5> :call <SID>StripTrailingWhitespaces()<CR>

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"Shortcut! Spell Checking toggle
map <silent><F6> :setlocal spell! spelllang=en_us<CR>

"Tabs manipulation
set switchbuf=usetab
nnoremap <F7> :sbnext<CR>
nnoremap <S-F7> :sbprevious<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>


"Tagbar to work
 nmap <F8> :TagbarToggle<CR>

"NerdTree open CTRL+n
 noremap <C-n> :NERDTreeToggle<CR>

"Search replaces n number of times
nnoremap Q :normal n.<CR>

"Open URI under cursor.
 nmap ob <Plug>(openbrowser-open)

"Open selected URI.
 vmap os <Plug>(openbrowser-open)

"Comment out the shell script with a key stroke , which is forward slash c
"like this \c

 autocmd FileType *  nnoremap <buffer> <localleader>c I#<esc>


"Google calendar process

let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
let g:calendar_google_event = 1
let g:calendar_event_start_time= 1
"let g:calendar_frame = 'default'
source ~/.cache/calendar.vim/credentials.vim


"Vimade settings

let g:vimade = {}
let g:vimade.fadelevel = 0.7
let g:vimade.enablesigns = 1



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

"Move between splits
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

"Open this file in vertical split for quick reference
nnoremap <leader>vr :vsplit ~/.vimrc<cr>

"After editing this file must be sourced ,so the changes take effect on
"current session
nnoremap <leader>sv :source ~/.vimrc<cr>

"To insert email address with a shortcut @@ ,and then need to press space after that
iabbrev @@    unixbhaskar@gmail.com

" Auto loading .vimrc once saved
if has('autocmd')
    augroup reload_vimrc
        autocmd!
        autocmd! BufWritePost ~/.vimrc nested source %
    augroup END
endif

"conditionally auto creating directory if it is not exists.

augroup AutoMkdir
    autocmd!
    autocmd  BufNewFile  *  :call EnsureDirExists()
augroup END
function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call AskQuit("Directory '" . required_dir . "' doesn't exist.", "&Create it?")

	try
            call mkdir( required_dir, 'p' )
        catch
            call AskQuit("Can't create '" . required_dir . "'", "&Continue anyway?")
        endtry
    endif
endfunction

function! AskQuit (msg, proposed_action)
    if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
        exit
    endif
endfunction

"fzf related customization

let $FZF_DEFAULT_OPTS .= ' --inline-info'

"Shortcut :Files bring up the fuzzy finder
 map <C-f> <Esc><Esc>:Files!<CR>
"Shortcut :Blines  in file and go to chosen line
inoremap <C-f> <Esc><Esc>:Blines!<CR>

" Always enable preview window on the right with 60% width
let g:fzf_preview_window = 'right:60%'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Word completion with custom spec with popup layout option
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})


" This is for Short:c:ce>t  showmap#helper("<Space>t","n")ut to enable pop  up to remember the key combination in vim
let mapleader=";"

"Shortcut show shortcut menu and run chosen shortcut
Shortcut for shortcuts to work in vim
       \ noremap <silent> <Leader><Leader> :Shortcuts<Return>

Shortcut fallback to shortcut menu on partial entry
                         \ noremap <silent> <Leader> :Shortcuts<Return>

Shortcut! Paste mode toggle by pressing F2

Shortcut! GitCommit popup messages of the specific line of code by pressing  \g

Shortcut! Tagbar to toggle by  F8

Shortcut! NerdTree to open by pressing C-n

Shortcut! BrowserOpen for under cursor url by pressing "ob" in normal mode

Shortcut! UrlSelect  open the url by pressing quickly "os" in normal mode

Shortcut! SpellChecking toggle by pressing F6

Shortcut! SplitWindow move between by pressing  C-h C-j C-K C-l

Shortcut! :Files bring up the fuzzy finder and aslo possible by  C-f

Shortcut! :Blines bring up the fuzzy finder

Shortcut! TabsManaged by F7 and Shift-F7 and CTRL-> CTRL<-

Shortcut! Calendar to show by write Calendar at : prompt

Shortcut! Autocomplete suggestions select by pressing CTRL+Shift+n

Shortcut! Comment line of code by pressing \c

Shortcut! GitHubBrowse if you run "!hub browse" from : this promt inside git repo,it will open the repo page in GitHub

Shortcut! LaTexOpenPDF for live review by pressing \p in normal mode

Shortcut! LaTexCompile just press \ll  might not get feedback of this command,bacasue it worked in the background

Shortcut! LaTexPrevOnOff  toggle by pressing \o in normal mode

Shortcut! MovingAroundLongSentences  () search end of statement i.e for period and then w and b to move forward and backword fast

Shortcut! LongSentenceManeuver  gj and gk are for moving up and down in long sentences breaks up several lines long

Shortcut! ParagraphMovement   { this and this } jump between paragraphs

Shortcut! InsertEmail  in the insert mode type "@@" without quote

Shortcut! SelectVisually  Capital V will select entire line

Shortcut! ShowInVisibleChar by pressing <F4>

Shortcut! RemoveTrailingWhiteSpace by pressing <F5>

Shortcut! UndoLiveUpdateWindow by pressing <F3> in normal mode

Shortcut! FoldBehavior by using zi and za and zM and zv

Shortcut! ToCopyLine use :<lineno>t<dot> for current cursor position

Shortcut! RepeatReplaceNtimes by preseeing Q in normal mode