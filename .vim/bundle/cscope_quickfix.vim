" File: cscope_quickfix.vim
" Author: kino
" Version: 0.1
" Last Modified: Dec. 30, 2003
" 
" Overview
" ------------
" This script enables to use cscope with quickfix.
" 
" Preparation
" ------------
" You must prepare cscope and cscope database (cscope.out file).
" cscope is a tag tool like ctags, but unlike ctags, it is a cross referencing
" tool.
" If you don't know about cscope, see:
" :help cscope
" http://cscope.sourceforge.net/
" 
" Feature 1
" ------------
" This script adds a command ":Cscope", which is very similar to ":cscope find"
" command. But, this ":Cscope" command can be used with quickfix, and isn't
" needed cscope connection. So, you don't have to install vim with
" --enable-cscope.
"
" Feature 2
" ------------
" This script adds keymap macro as follows:
" <C-\> s: Find this C symbol
" <C-\> g: Find this definition
" <C-\> d: Find functions called by this function
" <C-\> c: Find functions calling this function
" <C-\> t: Find this text string
" <C-\> e: Find this egrep pattern
" <C-\> f: Find this file
" <C-\> i: Find files #including this file
" "this" means <cword> or <cfile> on the cursor.
"
" Feature 3
" --------------
" This script adds Tools and Popup menu as follows:
" "Symbols": Find this C symbol
" "Defines": Find this definition
" "Calls": Find functions called by this function
" "Globals": Find functions calling this function
" "Texts": Find this text string
" "Egrep": Find this egrep pattern
" "File": Find this file
" "Includes": Find files #including this file
" "Update cscope.out"

"
" Function
" --------------
" RunCscope({type}, {pattern} [,{file}])
"
" Command
" --------------
" Cscope {type} {pattern} [{file}]
"
" Variables
" --------------
" g:Cscope_OpenQuickfixWindow
" g:Cscope_JumpError
" g:Cscope_Keymap
" g:Cscope_PopupMenu
" g:Cscope_ToolMenu
"
" Install
" -------------
" Copy cscope_quickfix.vim file to plugin directory. 
" If you don't want to open quickfix window after :Cscope command, put a line
" in .vimrc like: 
" let Cscope_OpenQuickfixWindow = 0 
" If you don't want to jump first item after :Cscope command, put a line
" in .vimrc like: 
" let Cscope_JumpError = 0
" If you don't want to use keymap for :Cscope command, put a line in .vimrc
" like: 
" let Cscope_Keymap = 0
" If you want to use Popup menu for :Cscope command, put a line in .vimrc
" like: 
" let Cscope_PopupMenu = 1
" If you don't want to use Tools menu for :Cscope command, put a line in .vimrc
" like: 
" let Cscope_ToolsMenu = 0
"
if !exists("Cscope_OpenQuickfixWindow")
	let Cscope_OpenQuickfixWindow = 1
endif

if !exists("Cscope_JumpError")
	let Cscope_JumpError = 1
endif

if !exists("Cscope_Keymap")
	let Cscope_Keymap = 1
endif

if !exists("Cscope_PopupMenu")
	let Cscope_PopupMenu = 0
endif

if !exists("Cscope_ToolMenu")
	let Cscope_ToolMenu = 1
endif

" RunCscope()
" Run the cscope command using the supplied option and pattern
function! s:RunCscope(...)
	let usage = "Usage: Cscope {type} {pattern} [{file}]."
	let usage = usage . " {type} is [sgdctefi01234678]."
	if !exists("a:1") || !exists("a:2")
		echohl WarningMsg | echomsg usage | echohl None
		return
	endif
	let cscope_opt = a:1
	let pattern = a:2
	let openwin = g:Cscope_OpenQuickfixWindow
	let jumperr =  g:Cscope_JumpError
	if cscope_opt == '0' || cscope_opt == 's'
		let cmd = "cscope -L -0 " . pattern
	elseif cscope_opt == '1' || cscope_opt == 'g'
		let cmd = "cscope -L -1 " . pattern
	elseif cscope_opt == '2' || cscope_opt == 'd'
		let cmd = "cscope -L -2 " . pattern
	elseif cscope_opt == '3' || cscope_opt == 'c'
		let cmd = "cscope -L -3 " . pattern
	elseif cscope_opt == '4' || cscope_opt == 't'
		let cmd = "cscope -L -4 " . pattern
	elseif cscope_opt == '6' || cscope_opt == 'e'
		let cmd = "cscope -L -6 " . pattern
	elseif cscope_opt == '7' || cscope_opt == 'f'
		let cmd = "cscope -L -7 " . pattern
		let openwin = 0
		let jumperr = 1
	elseif cscope_opt == '8' || cscope_opt == 'i'
		let cmd = "cscope -L -8 " . pattern
	else
		echohl WarningMsg | echomsg usage | echohl None
		return
	endif
	if exists("a:3")
		let cmd = cmd . " " . a:3
	endif
	let cmd_output = system(cmd)

	if cmd_output == ""
		echohl WarningMsg | 
		\ echomsg "Error: Pattern " . pattern . " not found" | 
		\ echohl None
		return
	endif

	let tmpfile = tempname()
	let curfile = expand("%")

	if &modified && (!&autowrite || curfile == "")
		let jumperr = 0
	endif

	exe "redir! > " . tmpfile
	if curfile != ""
		silent echon curfile . " dummy " . line(".") . " " . getline(".") . "\n"
		silent let ccn = 2
	else
		silent let ccn = 1
	endif
	silent echon cmd_output
	redir END

	" If one item is matched, window will not be opened.
"	let cmd = "wc -l < " . tmpfile
"	let cmd_output = system(cmd)
"	exe "let lines =" . cmd_output
"	if lines == 2
"		let openwin = 0
"	endif

	let old_efm = &efm
	set efm=%f\ %*[^\ ]\ %l\ %m

	exe "silent! cfile " . tmpfile
	let &efm = old_efm

	" Open the cscope output window
	if openwin == 1
		botright copen
	endif

	" Jump to the first error
	if jumperr == 1
		exe "cc " . ccn
	endif

	call delete(tmpfile)
endfunction

" Define the set of Cscope commands
command! -nargs=* Cscope call s:RunCscope(<f-args>)

if g:Cscope_Keymap == 1
	nmap <C-\>s :Cscope s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>g :Cscope g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>d :Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
	nmap <C-\>c :Cscope c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>t :Cscope t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>e :Cscope e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>f :Cscope f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-\>i :Cscope i ^<C-R>=expand("<cfile>")<CR>$<CR>

	nmap <C-@>s :split<CR>:Cscope s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>g :split<CR>:Cscope g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>d :split<CR>:Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
	nmap <C-@>c :split<CR>:Cscope c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>t :split<CR>:Cscope t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>e :split<CR>:Cscope e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>f :split<CR>:Cscope f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-@>i :split<CR>:Cscope i ^<C-R>=expand("<cfile>")<CR>$<CR>

	nmap <C-@><C-@>s :vert split<CR>:Cscope s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>g :vert split<CR>:Cscope g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>d :vert split<CR>:Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
	nmap <C-@><C-@>c :vert split<CR>:Cscope c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>t :vert split<CR>:Cscope t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>e :vert split<CR>:Cscope e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@><C-@>f :vert split<CR>:Cscope f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-@><C-@>i :vert split<CR>:Cscope i ^<C-R>=expand("<cfile>")<CR>$<CR>
endif
if has('gui_running') && g:Cscope_PopupMenu == 1
	nmenu PopUp.-SEP3-	<Nop>
	nmenu PopUp.&Cscope.&Symbols :Cscope s <C-R>=expand("<cword>")<CR><CR>
	nmenu PopUp.&Cscope.&Defines :Cscope g <C-R>=expand("<cword>")<CR><CR>
	nmenu PopUp.&Cscope.&Calls :Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
	nmenu PopUp.&Cscope.&Globals :Cscope c <C-R>=expand("<cword>")<CR><CR>
	nmenu PopUp.&Cscope.&Texts :Cscope t <C-R>=expand("<cword>")<CR><CR>
	nmenu PopUp.&Cscope.&Egrep :Cscope e <C-R>=expand("<cword>")<CR><CR>
	nmenu PopUp.&Cscope.&File :Cscope f <C-R>=expand("<cword>")<CR><CR>
	nmenu PopUp.&Cscope.&Includes :Cscope i ^<C-R>=expand("<cword>")<CR>$<CR>
	nmenu PopUp.&Cscope.-SEP1-	<Nop>
	nmenu PopUp.&Cscope.&Update\ cscope\.out :!cscope -b -R<CR>
endif
if has('gui_running') && g:Cscope_ToolMenu == 1
	nmenu &Tools.-SEP3-	<Nop>
	nmenu &Tools.&Cscope.&Symbols :Cscope s <C-R>=expand("<cword>")<CR><CR>
	nmenu &Tools.&Cscope.&Defines :Cscope g <C-R>=expand("<cword>")<CR><CR>
	nmenu &Tools.&Cscope.&Calls :Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
	nmenu &Tools.&Cscope.&Globals :Cscope c <C-R>=expand("<cword>")<CR><CR>
	nmenu &Tools.&Cscope.&Texts :Cscope t <C-R>=expand("<cword>")<CR><CR>
	nmenu &Tools.&Cscope.&Egrep :Cscope e <C-R>=expand("<cword>")<CR><CR>
	nmenu &Tools.&Cscope.&File :Cscope f <C-R>=expand("<cword>")<CR><CR>
	nmenu &Tools.&Cscope.&Includes :Cscope i ^<C-R>=expand("<cword>")<CR>$<CR>
	nmenu &Tools.&Cscope.-SEP1-	<Nop>
	nmenu &Tools.&Cscope.&Update\ cscope\.out :!cscope -b -R<CR>
endif
" vim:set ts=4 sw=4 filetype=vim:
