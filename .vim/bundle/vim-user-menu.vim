" ·•« User Menu Plugin »•· ·•« zphere-zsh/vim-user-popmenu »•·
" Copyright (c) 2020 « Sebastian Gniazdowski ».
" License: « Gnu GPL v3 ».
" 
" Example user-menu «list» of «dictionaries»:
" 
" let g:user_menu = [
"     \ [ "Reload",      #{ type: "cmds", body: ":edit!" } ],
"     \ [ "Quit Vim",    #{ type: "cmds", body: ":qa!" } ],
"     \ [ "New Window",  #{ type: "keys", body: "\<C-w>n" } ],
"     \ [ "Load passwd", #{ type: "expr", body: "LoadPasswd()" } ]
" \ ]
" 
" The "syntax" of the user-menu «list» of «dictionaries» is:
" [ 
"     \ [ "Item text …", #{ type: "type-kind", body: "the command body" } ],
"       ···
"       ···
"     \ [ "Item N text …", #{ <configuration 2> } ]
" \ ]
" 
" The meaning of the dictionary keys:
"
" – The "type" is one of: "cmds", "expr", "norm", "keys", "other-item".
"
" – The "{command body}" is either:
"   – A Ex command, like ":w" or "w". Type: "cmds" causes such command to be
"     run.
"   – An expression code, like, e.g.: "MyFunction()". Type: "expr".
"   – A sequence of norm commands, like, e.g.: "\<C-W>gf". Type: "norm" and
"     "norm!".
"   – A sequence of keys to feed into the editor simulating input, like, e.g.:
"     "\<C-w>n". Type: "keys".
"   – An item text or an ID of the other user menu entry, e.g.: "Open …" or "1".
"     Type "other-item" will cause the given other menu item to be run, only. 
"   
" There are also some optional, advanced keys of the dictionary:
" [ [ "…", #{ …,
"     \   opts: "options",
"     \   smessage: "start-message-text",
"     \   message: "message-text",
"     \   prompt: "prompt-text",
"     \   chain: "text-or-id",
"     \   body2: "additional command body of type <cmds>",
"     \   predic: "expression",
"     \ }
" \ ] ]
"   
" – The "options" is a comma- or space-separated list of subset of these
"   options: "keep-menu-open", "in-normal", "in-insert",
"   "in-visual", "in-cmds", "in-sh", "always-show",
"   "exit-to-norm".
"
"   – The "keep-menu-open" option causes the menu to be reopened immediately
"     after the selected command will finish executing.
"   – The "in-…" options show the item only if the menu is started in the
"     given mode, for example when inserting text, unless also the "always-show"
"     option is specified, in which case the item is being always displayed,
"     however it's executed *only* in the given mode (an error is displayed if
"     the mode is wrong).
"   – The "exit-to-norm" option causes the currently typed-in command (i.e.:
"     the text: ":… text …" in the command line window) to be discarded when the
"     menu is started (otherwise the text/the command is being always restored
"     after the menu closes → right before executing the selected command; this
"     allows to define a menu item that does something with the command, e.g.:
"     quotes slashes within it).
"
" – The "text-or-id" is either the text of the other user-menu item (the one to
"   chain-up/run after the edited item) or an ID of it.
"
" – The "start-message-text" is a message text to be shown *before* running the
"   command. It can start with a special string: "hl:<HL-group>:…" to show the
"   message in a specified color. There are multiple easy to use hl-groups, like
"   green,lgreen,yellow,lyellow,lyellow2,blue,blue2,lblue,lblue2,etc.
"
" – The "message-text" is a message text to be shown after running the command.
"
" – The "prompt-text" is a prompt-message text to be show when asking for the
"   user input (which is then assigned to the g:user_menu_prompt_input).
"
" – The "additional command body" is an Ex command to be run immediately after
"   executing the main body ↔ the main command part.
" 

" FUNCTION: UserMenu_Start() {{{
func! UserMenu_Start(way)
    let s:way = a:way
    let s:cmds = ((s:way == "c2") ? (empty(getcmdline()) ? s:cmds : getcmdline()) : getcmdline())
    PRINT °°° UserMenu_Start °°° Mode: s:way ((!empty(s:cmds)) ? '←·→ Cmd: '.string(s:cmds):'')

    call s:UserMenu_EnsureInit()

    let l:state_to_desc = #{ n:'Normal', c:'Command Line', i:'Insert', v:'Visual', o:'o' }
    let l:state_to_desc['c2'] = l:state_to_desc['c']
    if s:way !~ '\v^c2=$'
        PRINT 9 User Menu started in l:state_to_desc[s:way] mode.
    elseif s:way =~ '\v^c2=$'
        " Special actions needed for command-line state. 
        if s:way == 'c'
            call s:UserMenu_BufOrSesVarSet("user_menu_cmode_cmd", ':'.s:cmds)
            call s:UserMenu_BufOrSesVarSet("user_menu_init_cmd_mode", 'should-initialize')
            call feedkeys("\<ESC>","n")
            call add(s:timers, timer_start(10, function("s:deferredMenuReStart")))
            return ""
        endif

        let s:cmdline_like_msg = s:cmds
        if s:way == 'c2'
	    if !s:state_restarting
		7PRINT! p:1.5:hl:gold:User Menu started in Command-Line mode. The current-command line is:
	    endif
            let s:cmdline_like_msg = "hl:None::" . s:cmdline_like_msg . "█"
            7PRINT! s:cmdline_like_msg
        endif
    endif
    let s:state_restarting = 0

    let [opr,ops] = [ '(^|[[:space:]]+|,)', '([[:space:]]+|,|$)' ]

    " The source of the menu…
    let menu = deepcopy(get(g:,'user_menu', g:user_menu_default))
    let idx = 0
    for mitem in menu
        if type(mitem) == 1 && mitem =~ '^KIT:'
            let menu[idx] = deepcopy(g:user_menu_kit[mitem])
        " let g:user_menu = [ ["custom-name", "KIT:…", #{opts:'…'} ], … ]
        elseif type(mitem) == 3 && mitem[1] =~ '^KIT:' && len(mitem) == 3 && type(mitem[2]) == 4
            let menu[idx] = [ mitem[0], deepcopy(g:user_menu_kit[mitem[1]][1]) ]
            let menu[idx][1]['opts'] = deepcopy(mitem[2]['opts'])
        " let g:user_menu = [ ["custom-name", "KIT:…" ], … ]
        elseif type(mitem) == 3 && mitem[1] =~ '^KIT:'
            let menu[idx] = [ mitem[0], deepcopy(g:user_menu_kit[mitem[1]][1]) ]
        " let g:user_menu = [ #{ kit:"…", name:"…", opts:'…' }, … ]
        elseif type(mitem) == 4
            if !has_key(mitem, 'kit')
                7PRINT p:2:Error: The \g:user_menu entry doesn't have the 'kit' key in the dictionary.
                continue
            endif
            if mitem['kit'] !~ '^KIT:'
                let mitem['kit'] = 'KIT:'.mitem['kit']
            endif
            let menu[idx] = [ has_key(mitem, 'name') ? mitem['name'] : deepcopy(g:user_menu_kit[mitem['kit'][0]]),
                        \ deepcopy(g:user_menu_kit[mitem['kit']][1]) ]
            if has_key(mitem, 'opts')
                let menu[idx][1]['opts'] = mitem['opts']
            endif
        endif
        let idx += 1
    endfor
    " … and the temporary (it'll exist till the selection), built effect of it.
    let s:current_menu[bufnr()] = []
    " The list of items passed to popup_menu()
    let items = []
    for entry in menu
        " Fetch the options of the item.
	let opts_key = get(entry[1], 'opts', '')
	let opts_in = (type(opts_key) == 3) ? opts_key : split(opts_key, '\v(\s+|,)')
	call add(entry, {})
	call filter( opts_in, "!empty(extend(entry[2], { v:val : 1 }))" )
	let s:opts = entry[2]
'
        " Verify show-if
        if has_key(entry[1], 'show-if')
            if !eval(entry[1]['show-if']) | continue | endif
        endif

        let [reject,accept] = [ 0, 0 ]
        " The item shown only when the menu started in insert mode?
        if has_key(s:opts, 'in-insert') && !has_key(s:opts,'always-show')
            if s:way !~# '\v^(R[cvx]=|i[cx]=)' | let reject += 1 | else | let accept += 1 | endif
        endif
        " The item shown only when the menu started in normal mode?
        if has_key(s:opts, 'in-normal') && !has_key(s:opts,'always-show')
            if s:way !~# '\v^n(|o|ov|oV|oCTRL-V|iI|iR|iV).*' | let reject += 1 | else | let accept += 1 | endif
        endif
        " The item shown only when the menu started in visual mode?
        if has_key(s:opts, 'in-visual') && !has_key(s:opts,'always-show')
            if s:way !~# '\v^([vV]|CTRL-V|[sS]|CTRL-S)$' | let reject += 1 | else | let accept += 1 | endif
        endif
        " The item shown only when the menu started when entering commands?
        if has_key(s:opts, 'in-ex') && !has_key(s:opts,'always-show')
            if s:way !~# '\v^c[ve]=' | let reject += 1 | else | let accept += 1 | endif
        endif
        " The item shown only when the menu started when a job is running?
        if has_key(s:opts, 'in-sh') && !has_key(s:opts,'always-show')
            if s:way !~# '\v^[!t]$' | let reject += 1 | else | let accept += 1 | endif
        endif

        if reject && ! accept
            continue
        endif
        " Support embedding variables in the text via {var}.
        let entry[0] = s:UserMenu_ExpandVars(entry[0])
        call add( items, entry[0] )
        call add( s:current_menu[bufnr()], entry )
    endfor

    hi! UMPmenu ctermfg=220 ctermbg=darkblue
    hi! UMPmenuSB ctermfg=220 ctermbg=darkblue
    hi! UMPmenuTH ctermfg=220 ctermbg=darkblue
    hi! PopupSelected ctermfg=17 ctermbg=lightblue
    hi! PmenuSel ctermfg=17 ctermbg=lightblue

    call popup_menu( items, #{ 
                \ callback: 'UserMenu_MainCallback',
                \ filter: 'UserMenu_KeyFilter',
                \ filtermode: "a",
                \ time: 30000,
                \ mapping: 0,
                \ border: [ ],
                \ fixed: 1,
                \ wrap: 0,
                \ maxheight: &lines-8,
                \ maxwidth: &columns-20,
                \ flip: 1,
                \ title: ' VIM User Menu ≈ ' . l:state_to_desc[s:way] . ' ≈ ',
                \ drag: 1,
                \ resize: 1,
                \ close: 'button',
                \ highlight: 'UMPmenu',
                \ scrollbar: 1,
                \ scrollbarhighlight: 'UMPmenuSB',
                \ thumbhighlight: 'UMPmenuTH',
                \ cursorline: 1,
                \ borderhighlight: [ 'um_gold', 'um_gold', 'um_gold', 'um_gold' ],
                \ padding: [ 1, 1, 1, 1 ] } )
    redraw

    return ""
endfunc " }}}
" FUNCTION: UserMenu_MainCallback() {{{
func! UserMenu_MainCallback(id, result)
    " Clear the message window.
    echom ""
    " Carefully establish the selection and its data.
    let [s:item,s:got_it,s:result,s:type,s:body] = [ [ "", {} ], 0, a:result, "", "" ]
    if a:result > 0 && a:result <= len(s:current_menu[bufnr()])
        let [s:item,s:got_it] = [s:current_menu[bufnr()][a:result - 1], 1]
        let [s:type,s:body] = [s:item[1]['type'],s:item[1]['body']]
    endif

    " Important, base debug log.
    2PRINT °° Callback °° °id° ≈≈ s:result ←·→ (s:got_it ? string(s:item[0]).' ←·→ TPE ·'.s:type.'· BDY ·'.s:body.'·' : '≠')

    if s:got_it
        let s:opts = s:item[2]

        " Reopen the menu?
        if has_key(s:opts, 'keep-menu-open')
            call add(s:timers, timer_start(170, function("s:deferredMenuReStart")))
            let s:state_restarting = 1
        endif
    endif

    " Should restore the command line?
    let s:had_cmd = 0
    if !empty(s:UserMenu_BufOrSesVar("user_menu_cmode_cmd")) && !s:state_restarting
	" TODO2: timer, aby przetworzyć te klawisze przed wywołaniem komendy
        call add(s:timers,timer_start(5, function("s:UserMenu_RestoreCmdLine")))
	let s:had_cmd = 1
    endif
    call s:UserMenu_CleanupSesVars(s:way !~ '\v^c.*' ? 1 : 0)

    " The menu has been canceled? (ESC, ^C, cursor move)
    if !s:got_it
        if a:result > len(a:result)
            0PRINT Error: the index is too large →→ ••• s:result > len(s:current_menu) •••
        endif
        return
    endif

    " Output message before the command?
    call s:UserMenu_DeployDeferred_TimerTriggered_Message(s:item[1], 'smessage', -1)

    " Continue in the callback to fully leave the popup.
    call add( s:timers, timer_start(10, function("s:UserMenu_ExecuteCommand")) )
endfunction
" }}}
" FUNCTION: s:UserMenu_ExecuteCommand() {{{
func! s:UserMenu_ExecuteCommand(timer)
    call filter( s:timers, 'v:val != a:timer' )

    " Read the attached action specification and perform it.
    if s:type == 'cmds'
        exe s:body
    elseif s:type == 'expr'
        call eval(s:body)
    elseif s:type =~# '\v^norm(\!|)$'
        exe s:type s:body
    elseif s:type == 'keys'
        call feedkeys(s:body,"n")
    else
        0PRINT Unrecognized ·item· type: • s:type •
    endif

    " Output message after the command?
    call s:UserMenu_DeployDeferred_TimerTriggered_Message(s:item[1], 'message', 1)

    " Cancel ex command?
    if has_key(s:opts, 'exit-to-norm') && s:had_cmd
	call feedkeys("\<C-U>\<BS>","n")
    endif
endfunc
" }}}
" FUNCTION: s:UserMenu_InitBufAdd() {{{
" A function that's called when a new buffor is created.
func! s:UserMenu_InitBufAdd() 
    let b:user_menu_cmode_cmd = ""
    let s:current_menu = {}
    let s:current_menu[bufnr()] = []
endfunc
" }}}
" FUNCTION: s:UserMenu_InitBufRead() {{{
" A funcion that's called when the buffer is loaded.
func! s:UserMenu_InitBufRead()
    call s:UserMenu_InitBufAdd()
endfunc
" }}}
" FUNCTION: s:UserMenu_EnsureInit() {{{
func! s:UserMenu_EnsureInit()
    if !exists("b:user_menu_cmode_cmd")
        2PRINT No \b:var detected °° calling: °° « \s:UserMenu_InitBufAdd() » …
        call s:UserMenu_InitBufAdd()
        return 0
    endif
    return 1
endfunc
" }}}

"""""""""""""""""" HELPER FUNCTIONS {{{

" FUNCTION: UserMenu_KeyFilter() {{{
func! UserMenu_KeyFilter(id,key)
    redraw
    let s:tryb = s:UserMenu_BufOrSesVar("user_menu_init_cmd_mode")
    let s:key = a:key
    if s:way == 'c' | call add(s:timers, timer_start(250, function("s:redraw"))) | endif
    if s:tryb == 'should-initialize'
        3PRINT s:way ←←← s:key →→→ «INIT-path» °°° user_menu_init_cmd_mode ←·→
                    \ s:tryb °°° \s:way ←·→ s:way °°° \a:key ←·→ s:key
        call s:UserMenu_BufOrSesVarSet("user_menu_init_cmd_mode", '')
        " Consume (still somewhat conditionally ↔ depending on the filter)
        " only the (very first) Up-cursor key. It is sent automatically right
        " after starting the menu from the «active-command line» state.
        return (a:key == "\<Up>") ? popup_filter_menu(a:id, a:key) : 0
    else
        let s:result = popup_filter_menu(a:id, a:key)
        3PRINT s:way ←←← s:key →→→ filtering-path °°° user_menu_init_cmd_mode
                    \ s:tryb °°° ret ((s:way=='c') ? '~forced-1'.s:result : s:result) °°°
        redraw
        return s:result
    endif
endfunc " }}}
" FUNCTION: s:UserMenu_DeployDeferred_TimerTriggered_Message() {{{
func! s:UserMenu_DeployDeferred_TimerTriggered_Message(dict,key,...)
    if a:0 && a:1 > 0
        let [s:msgs, s:msg_idx] = [ exists("s:msgs") ? s:msgs : [], exists("s:msg_idx") ? s:msg_idx : 0 ]
        let [s:pauses, s:pause_idx] = [ exists("s:pauses") ? s:pauses : [], exists("s:pause_idx") ? s:pause_idx : 0 ]
    endif
    if has_key(a:dict,a:key) 
        let [s:pause,s:msg] = s:UserMenu_GetPrefixValue('p%[ause]', a:dict[a:key])
        if a:0 && a:1 >= 0
            call add(s:msgs, s:msg)
            call add(s:pauses, s:pause)
            call add(s:timers, timer_start(a:0 >= 2 ? a:2 : 20, function("s:deferredMessageShow")))
            let s:msg_idx = s:msg_idx == -1 ? 0 : s:msg_idx
        else
            let s:msg = s:UserMenu_ExpandVars(s:msg)
            if type(s:msg) == 3 || !empty(substitute(s:msg,"^hl:[^:]*:","","g"))
                if type(s:msg) == 3
                    call s:msg(10, s:msg)
                else
                    10PRINT s:msg
                endif
                redraw
                call s:UserMenu_DoPause(s:pause)
            endif
        endif
    endif
endfunc
" }}}
" FUNCTION: s:msg(hl,...) {{{
" 0 - error         LLEV=0 will show only them
" 1 - warning       LLEV=1
" 2 - info          …
" 3 - notice        …
" 4 - debug         …
" 5 - debug2        …
func! s:msg(hl, ...)
    " Log only warnings and errors by default.
    if a:hl < 7 && a:hl > get(g:,'user_menu_log_level', 1) || a:0 == 0
        return
    endif

    " Make a copy of the input.
    let args = deepcopy(type(a:000[0]) == 3 ? a:000[0] : a:000)
    if a:hl >= 7 && args[0] =~ '\v^\[\d+\]$' | let args = args[1:] | endif
    let hl = a:hl >= 7 ? (a:hl-7) : a:hl

    " Expand any variables and concatenate separated atoms wrapped in parens.
    let start_idx = -1
    let new_args = []
    for idx in range(len(args))
        let arg = args[idx]
        " Unclosed paren?
        " Discriminate two special cases: (func() and (func(sub_func())
        if start_idx == -1 && arg =~# '\v^\(.*([^)]|\([^)]*\)|\([^(]*\([^)]*\)[^)]*\))$'
            let start_idx = idx
        " A free, closing paren?
        elseif start_idx >= 0 && arg =~# '\v^[^(].*\)$' && arg !~ '\v\([^)]*\)$'
            call add(new_args,eval(join(args[start_idx:idx])))
            let start_idx = -1
            continue
        endif
    
        if start_idx == -1
            " A variable?
            if arg =~# '\v^\s*[sgb]:[a-zA-Z_][a-zA-Z0-9_]*%(\[[^]]+\])=\s*$'
                let arg = s:UserMenu_ExpandVars("{".arg."}")
            " A function call or an expression wrapped in parens?
            elseif arg =~# '\v^\s*(([sgb]:)=[a-zA-Z_][a-zA-Z0-9_-]*)=\s*\(.*\)\s*$'
                let arg = eval(arg)
            " A \-quoted atom?
            elseif arg[0] == '\'
                let arg = arg[1:]
            endif

            " Store/save the element.
            call add(new_args, arg)
        endif
    endfor
    let args = new_args

    " Finally: detect any hl:…: prefix, select the color, output the message.
    let c = ["Error", "WarningMsg", "um_gold", "um_green4", "um_blue", "None"]
    " Separate-out the possible hl:…: infix – try in/from the first 3 arguments.
    let [val,new_arg] = s:UserMenu_GetPrefixValue("hl", join(args[0:2]))
    let args[0:min([len(args)-1,2])] = extend([new_arg],repeat([''], min([len(args),3]) - 1))
    let args = filter(args, "v:val != ''")
    let hl = !empty(val) ? (val =~# '^\d\+$' ? c[val] : val) : c[hl]
    let hl = (hl !~# '\v^(\d+|um_[a-z0-9_]+|WarningMsg|Error)$') ? 'um_'.hl : hl
    exe 'echohl ' . hl
    redraw
    echom join( args )
    echohl None 
endfunc
" }}}
" FUNCTION: s:msgcmdimpl(hl,...) {{{
func! s:msgcmdimpl(hl, bang, linenum, ...)
    if(!empty(a:bang))
        call s:UserMenu_DeployDeferred_TimerTriggered_Message(
                    \ #{ m: (a:hl < 7 ? extend(["[".a:linenum."]"], a:000[0]) : a:000[0]) }, 'm', 1)
    else
        if exists("a:000[0][1]") && type(a:000[0][1]) == 1 && a:000[0][1] =~ '\v^\[\d+\]$'
            call s:msg(a:hl, a:000[0])
        else
            call s:msg(a:hl, extend(["[".a:linenum."]"], a:000[0]))
        endif
    endif
endfunc
" }}}
" FUNCTION: s:redraw(timer) {{{
func! s:redraw(timer)
    call filter( s:timers, 'v:val != a:timer' )
    6PRINT △ redraw called △
    redraw
endfunc
" }}}
" FUNCTION: s:deferredMenuReStart(timer) {{{
func! s:deferredMenuReStart(timer)
    call filter( s:timers, 'v:val != a:timer' )
    if s:way =~ '^c.*'
        call feedkeys("\<Up>","n")
    endif
    call UserMenu_Start(s:way == 'c' ? 'c2' : s:way)
    if s:way !~ '\v^c.*'
        let l:state_to_desc = #{ n:'Normal', i:'Insert', v:'Visual', o:'o' }
        7PRINT hl:lyellow3:Opened again the menu in l:state_to_desc[s:way] mode.
    endif
    redraw
endfunc
" }}}
" FUNCTION: s:deferredMessageShow(timer) {{{
func! s:deferredMessageShow(timer)
    call filter( s:timers, 'v:val != a:timer' )
    if type(s:msgs[s:msg_idx]) == 3
        call s:msg(10,s:UserMenu_ExpandVars(s:msgs[s:msg_idx]))
    else
        10PRINT s:UserMenu_ExpandVars(s:msgs[s:msg_idx])
    endif
    let pause = s:pauses[s:pause_idx]
    let [s:msg_idx, s:pause_idx] = [s:msg_idx+1, s:pause_idx+1]
    redraw
    call s:UserMenu_DoPause(pause)
endfunc
" }}}
" FUNCTION: s:UserMenu_DoPause(pause_value) {{{
func! s:UserMenu_DoPause(pause_value)
    if a:pause_value =~ '\v^-=\d+(\.\d+)=$'
        let s:pause_value = float2nr(round(str2float(a:pause_value) * 1000.0))
    endif
    if s:pause_value =~ '\v^-=\d+$' && s:pause_value > 0
        call s:UserMenu_PauseAllTimers(1, s:pause_value + 10)
        exe "sleep" s:pause_value."m"
    endif
endfunc
" }}}
" FUNCTION: s:UserMenu_BufOrSesVar() {{{
" Returns b:<arg> or s:<arg>, if the 1st one doesn't exist.
func! s:UserMenu_BufOrSesVar(var_to_read,...)
    let s:tmp = a:var_to_read
    if exists("s:" . a:var_to_read)
        return get( s:, a:var_to_read, a:0 ? a:1 : '' )
    elseif exists("b:" . a:var_to_read)
        return get( b:, a:var_to_read, a:0 ? a:1 : '' )
    else
        6PRINT ·• Warning «Get…» •· →→ non-existent parameter given: ° s:tmp °
        return a:0 ? a:1 : ''
    endif
endfunc
" }}}
" FUNCTION: s:UserMenu_CleanupSesVars() {{{
" Returns b:<arg> or s:<arg>, if the 1st one doesn't exist.
func! s:UserMenu_CleanupSesVars(...)
    if has_key(s:,'user_menu_init_cmd_mode')
        call remove(s:,'user_menu_init_cmd_mode')
    endif
    if a:0 && a:1
        if has_key(s:,'user_menu_cmode_cmd')
            call remove(s:,'user_menu_cmode_cmd')
        endif
    endif
endfunc
" }}}
" FUNCTION: s:UserMenu_BufOrSesVarSet() {{{
" Returns b:<arg> or s:<arg>, if the 1st one doesn't exist.
func! s:UserMenu_BufOrSesVarSet(var_to_set, value_to_set)
    let s:tmp = a:var_to_set
    if exists("s:" . a:var_to_set)
        let s:[a:var_to_set] = a:value_to_set
    else
        if exists("b:" . a:var_to_set)
            let b:[a:var_to_set] = a:value_to_set
            return 1
        else
            6PRINT ·• Warning «Set…» •· →→ non-existent parameter given: ° s:tmp °
            let b:[a:var_to_set] = a:value_to_set
            if exists("b:" . a:var_to_set)
                let b:[a:var_to_set] = a:value_to_set
                return 1
            else
                let s:[a:var_to_set] = a:value_to_set
                return 0
            endif
        endif
    endif
endfunc
" }}}
" FUNCTION: s:UserMenu_ExpandVars {{{
" It expands all {:command …'s} and {[sgb]:user_variable's}.
func! s:UserMenu_ExpandVars(text_or_texts)
    if type(a:text_or_texts) == 3
        " List input.
        let texts=deepcopy(a:text_or_texts)
        let idx = 0
        for t in texts
            let texts[idx] = substitute(t, '\v\{((:[^}]+|([sgb]\:|\&)[a-zA-Z_][a-zA-Z0-9_]*%(\[[^]]+\])=))\}', '\=((submatch(1)[0] == ":") ? ((submatch(1)[1] == ":") ? execute(submatch(1))[1:] : execute(submatch(1))[1:0]) : (exists(submatch(1)) ? eval(submatch(1)) : submatch(1)))', 'g')
            let idx += 1
        endfor
        return texts
    else
        " String input.
        return substitute(a:text_or_texts, '\v\{((:[^}]+|([sgb]\:|\&)[a-zA-Z_][a-zA-Z0-9_]*%(\[[^]]+\])=))\}', '\=((submatch(1)[0] == ":") ? ((submatch(1)[1] == ":") ? execute(submatch(1))[1:] : execute(submatch(1))[1:0]) : (exists(submatch(1)) ? eval(submatch(1)) : submatch(1)))', 'g')
    endif
endfunc
" }}}
" FUNCTION: s:UserMenu_GetPrefixValue(pfx, msg) {{{
func! s:UserMenu_GetPrefixValue(pfx, msg)
    let mres = matchlist( (type(a:msg) == 3 ? a:msg[0] : a:msg),'\v^(.{-})'.a:pfx.':([^:]*):(.*)$' )
    " Special case → a:msg is a List:
    if type(a:msg) == 3 && !empty(mres)
        let cpy = deepcopy(a:msg)
        " Update the message with the content without the prefix-value:
        let cpy[0] = mres[1].mres[3]
        return [mres[2],cpy]
    else
        " Regular case → a:msg is a String or no match
        return empty(mres) ? [0,a:msg] : [ mres[2], mres[1].mres[3] ]
    endif
endfunc
" }}}
" FUNCTION: s:UserMenu_RestoreCmdLineFrom() {{{
func! s:UserMenu_RestoreCmdLine(timer)
    call filter( s:timers, 'v:val != a:timer' )
    call feedkeys(":\<C-U>".(s:UserMenu_BufOrSesVar("user_menu_cmode_cmd")[1:]),"ntxi!")
    call s:UserMenu_BufOrSesVarSet("user_menu_cmode_cmd", "")
    redraw
endfunc
" }}}

" FUNCTION: s:UserMenu_PauseAllTimers() {{{
func! s:UserMenu_PauseAllTimers(pause,time)
    for t in s:timers
        call timer_pause(t,a:pause)
    endfor

    if a:pause && a:time > 0
        " Limit the amount of time of the pause.
        call add(s:timers, timer_start(a:time, function("s:UserMenu_UnPauseAllTimersCallback")))
    endif
endfunc
" }}}
" FUNCTION: s:UserMenu_UnPauseAllTimersCallback() {{{
func! s:UserMenu_UnPauseAllTimersCallback(timer)
    call filter( s:timers, 'v:val != a:timer' )
    for t in s:timers
        call timer_pause(t,0)
    endfor
endfunc
" }}}

"""""""""""""""""" THE END OF THE HELPER FUNCTIONS }}}

"""""""""""""""""" UTILITY FUNCTIONS {{{

func! Flatten(list)
    let new_list = []
    for el in a:list
        if type(el) == 3
            call extend(new_list, el)
        else
            call add(new_list, el)
        endif
    endfor
    return new_list
endfunc

func! Mapped(fn, l)
    let new_list = deepcopy(a:l)
    call map(new_list, string(a:fn) . '(v:val)')
    return new_list
endfunc

func! Filtered(fn, l)
    let new_list = deepcopy(a:l)
    call filter(new_list, string(a:fn) . '(v:val)')
    return new_list
endfunc

func! FilteredNot(fn, l)
    let new_list = deepcopy(a:l)
    call filter(new_list, '!'.string(a:fn) . '(v:val)')
    return new_list
endfunc

func! CreateEmptyList(name)
    eval("let ".a:name." = []")
endfunc

"""""""""""""""""" THE END OF THE UTILITY FUNCTIONS }}}

"""""""""""""""""" THE SCRIPT BODY {{{

augroup UserMenu_InitGroup
    au!
    au BufAdd * call s:UserMenu_InitBufAdd()
    au BufRead * call s:UserMenu_InitBufRead()
augroup END

inoremap <expr> <F12> UserMenu_Start("i")
nnoremap <expr> <F12> UserMenu_Start("n")
vnoremap <expr> <F12> UserMenu_Start("v")
cnoremap <F12> <C-\>eUserMenu_Start("c")<CR>
" Following doesn't work as expected…
onoremap <expr> <F12> UserMenu_Start("o")

" Print command.
command! -nargs=+ -count=4 -bang -bar PRINT call s:msgcmdimpl(<count>,<q-bang>,expand("<sflnum>"),
           \ map([<f-args>], 'v:val =~ ''\v^[sbgla]:[a-zA-Z0-9_]+(\[[^]]+\])=$'' ? eval(v:val) : v:val'))

" Menu command.
command! Menu call UserMenu_Start("n")

" Common highlight definitions.
hi! um_norm ctermfg=7
hi! um_blue ctermfg=27
hi! um_blue1 ctermfg=32
hi! um_blue2 ctermfg=75
hi! um_lblue ctermfg=50
hi! um_lblue2 ctermfg=75 cterm=bold
hi! um_lblue3 ctermfg=153 cterm=bold
hi! um_bluemsg ctermfg=123 ctermbg=25 cterm=bold
hi! um_gold ctermfg=220
hi! um_yellow ctermfg=190
hi! um_lyellow ctermfg=yellow cterm=bold
hi! um_lyellow2 ctermfg=221
hi! um_lyellow3 ctermfg=226
hi! um_green ctermfg=green
hi! um_green2 ctermfg=35
hi! um_green3 ctermfg=40
hi! um_green4 ctermfg=82
hi! um_bgreen ctermfg=green cterm=bold
hi! um_bgreen2 ctermfg=35 cterm=bold
hi! um_bgreen3 ctermfg=40 cterm=bold
hi! um_bgreen4 ctermfg=82 cterm=bold
hi! um_lgreen ctermfg=lightgreen
hi! um_lgreen2 ctermfg=118
hi! um_lgreen3 ctermfg=154
hi! um_lbgreen ctermfg=lightgreen cterm=bold
hi! um_lbgreen2 ctermfg=118 cterm=bold
hi! um_lbgreen3 ctermfg=154 cterm=bold

" Session-variables initialization.
let [ s:msgs, s:msg_idx ] = [ [], -1 ]
let s:state_restarting = 0
let s:timers = []

" The default, provided menu.
let g:user_menu_default = [ "KIT:buffers", "KIT:jumps", "KIT:open", "KIT:save", 
            \ "KIT:save-all-quit", "KIT:toggle-vichord-mode", "KIT:toggle-auto-popmenu",
            \ "KIT:new-win", "KIT:visual-to-subst-escaped", "KIT:visual-yank-to-subst-escaped",
            \ "KIT:capitalize", "KIT:escape-cmd-line" ]

let g:user_menu_kit = {
            \ "KIT:buffers" : [ "° BUFFER «LIST» …",
                    \ #{ type: 'expr', body: "UserMenu_ProvidedKitFuns_BufferSelectionPopup()",
                            \ opts: [] } ],
            \ "KIT:jumps" : [ "° JUMP «LIST» …",
                    \ #{ type: 'expr', body: "UserMenu_ProvidedKitFuns_JumpSelectionPopup()",
                            \ opts: [] } ],
            \ "KIT:open" : [ "° Open …",
                        \ #{ type: 'cmds', body: ':Ex', opts: "in-normal",
                            \ smessage: "p:2:hl:lblue2:Launching file explorer… In 2 seconds…",
                            \ message: "p:1:hl:gold:Explorer started correctly."} ],
            \ "KIT:save" : [ "° Save current buffer",
                       \ #{ type: 'cmds', body: ':if !empty(expand("%")) && !&ro | w | endif',
                            \ smessage:'p:2:hl:1:{:let g:_sr = "" | if empty(expand("%")) | let
                                \ g:_m = "No filename for this buffer." | elseif &ro | let g:_m
                                    \ = "Readonly buffer." | else | let [g:_m,g:_sr] = ["","File
                                    \ saved under: " . expand("%")] | endif }
                                \{g:_m}',
                            \ opts: "in-normal", message: "p:1:hl:2:{g:_sr}" } ],
            \ "KIT:save-all-quit" :[ "° Save all & Quit",
                       \ #{ type: 'cmds', body: ':q', smessage: "p:2:hl:2:Quitting Vim
                           \… {:bufdo if !empty(expand('%')) && !&ro | w | else | if ! &ro |
                               \ w! .unnamed.txt | endif | endif}All files saved, current file
                               \ modified: {&modified}.", opts: "in-normal" } ],
            \ "KIT:toggle-vichord-mode" :[ "° Toggle completion-mode ≈ {g:vichord_search_in_let} ≈ ",
                        \ #{ show-if: "exists('g:vichord_omni_completion_loaded')",
                            \ type: 'expr', body: 'extend(g:, #{ vichord_search_in_let :
                            \ !get(g:,"vichord_search_in_let",0) })', opts: "keep-menu-open",
                            \ message: "p:1:hl:lblue2:The new state: {g:vichord_search_in_let}." } ],
            \ "KIT:toggle-auto-popmenu" :[ "° Toggle Auto-Popmenu Plugin ≈ {::echo get(b:,'apc_enable',0)} ≈ ",
                        \ #{ show-if: "exists('g:apc_loaded')",
                            \ type: 'cmds', body: 'if get(b:,"apc_enable",0) | ApcDisable |
                                \ else | ApcEnable | endif', opts: "keep-menu-open",
                            \ message: "p:1:hl:lblue2:The new state: {b:apc_enable}." } ],
            \ "KIT:new-win" :[ "° New buffer",
                        \ #{ type: 'norm', body: "\<C-W>n", opts: "in-normal",
                            \ message: "p:1:New buffer created."} ],
            \ "KIT:visual-to-subst-escaped" :[ "° The «visual-selection» in s/…/…/g escaped",
                        \ #{ type: 'keys', body: "y:let @@ = substitute(escape(@@,'/\\'),
                            \ '\\n','\\\\n','g')\<CR>:%s/\\V\<C-R>\"/", opts: "in-visual",
                            \ message:"p:1.5:The selection has been escaped. Here's the s/…/…/g command with it:"} ],
            \ "KIT:visual-yank-to-subst-escaped" :[ "° «Visual» yank in s/…/…/g escaped …",
                        \ #{ type: 'expr', body: "UserMenu_ProvidedKitFuns_StartSelectYankEscapeSubst()",
                            \ opts: "in-normal",
                            \ smessage:"p:1.5:Select some text and YANK to get it to :s/…/…/g"} ],
            \ "KIT:capitalize" :[ "° Upcase _front_ letters in the «selected» words",
                        \ #{ type: 'norm!', body: ':s/\%V\v\w+/\L\u\0/g'."\<CR>",
                            \ opts: "in-visual",
                            \ message:"p:1:All selected FRONT letters of WORDS are now upcase."} ],
            \ "KIT:escape-cmd-line" :[ "° Escape the «command-line»",
                        \ #{ type: 'keys', body: "\<C-bslash>esubstitute(escape(getcmdline(), ' \'),
                                \'\\n','\\\\n','g')\<CR>",
                            \ opts: ['in-ex'] } ]
            \ }

"""""""""""""""""" THE END OF THE SCRIPT BODY }}}

"""""""""""""""""" IN-MENU USE FUNCTIONS (THE PROVIDED-KIT FUNCTIONS) {{{

" FUNCTION: UserMenu_ProvidedKitFuns_StartSelectYankEscapeSubst() {{{
func! UserMenu_ProvidedKitFuns_StartSelectYankEscapeSubst()
    let s:y = maparg("y", "v")
    let s:v = maparg("v", "v")
    let s:esc = maparg("\<ESC>", "v")
    vnoremap y y:<C-R>=UserMenu_ProvidedKitFuns_EscapeYRegForSubst(@@,0)<CR>
    vnoremap v <ESC>v
    vnoremap <expr> <ESC> UserMenu_ProvidedKitFuns_EscapeYRegForSubst(@@,1)
    call feedkeys("v")
endfunc
" }}}
" FUNCTION: UserMenu_ProvidedKitFuns_EscapeYRegForSubst(sel,inactive) {{{
func! UserMenu_ProvidedKitFuns_EscapeYRegForSubst(sel,inactive)
    if !empty(s:y)
        exe 'vnoremap y ' . s:y
    else
        vunmap y
    endif
    if !empty(s:v)
        exe 'vnoremap v ' . s:v
    else
        vunmap v
    endif
    if !empty(s:esc)
        exe 'vnoremap <ESC> ' . s:esc
    else
        vunmap <ESC>
    endif
    if a:inactive
        5PRINT The ESC-mapping was restored to \(empty ↔ no mapping): °° ('»'.maparg('<ESC>','v').'«') °°
        7PRINT! p:0.5:hl:lbgreen2:The operation has been correctly canceled.
        return "\<ESC>"
    else
        return '%s/\V'.substitute(escape(a:sel,"/\\"),'\n','\\n','g').'/'
    endif
endfunc
" }}}

" FUNCTION: UserMenu_ProvidedKitFuns_BufferSelectionPopup() {{{
func! UserMenu_ProvidedKitFuns_BufferSelectionPopup()
    hi! UMPmenuBL ctermfg=82 ctermbg=darkblue
    hi! UMPmenuBLSB ctermfg=82 ctermbg=darkblue
    hi! UMPmenuBLTH ctermfg=82 ctermbg=darkblue
    hi! PopupSelected ctermfg=17 ctermbg=82
    hi! PmenuSel ctermfg=17 ctermbg=82

    let s:current_buffer_list = split(execute('filter! /\[Popup\]/ ls!'),"\n")
    call popup_menu(s:current_buffer_list, #{
                \ callback:'UserMenu_ProvidedKitFuns_BufferSelectionCallback',
                \ time: 30000,
                \ mapping: 0,
                \ border: [ ],
                \ fixed: 1,
                \ wrap: 0,
                \ maxheight: &lines-4,
                \ maxwidth: &columns-20,
                \ flip: 1,
                \ title: ' VIM User Menu ≈ Select The Buffer To Switch To: ≈ ',
                \ drag: 1,
                \ resize: 1,
                \ close: 'button',
                \ highlight: 'UMPmenuBL',
                \ scrollbar: 1,
                \ scrollbarhighlight: 'UMPmenuBLSB',
                \ thumbhighlight: 'UMPmenuBLTH',
                \ cursorline: 1,
                \ borderhighlight: [ 'um_green4', 'um_green4', 'um_green4', 'um_green4' ],
                \ padding: [ 2, 2, 2, 2 ] } )
endfunc
" }}}
" FUNCTION: UserMenu_ProvidedKitFuns_BufferSelectionCallback() {{{
func! UserMenu_ProvidedKitFuns_BufferSelectionCallback(id, result)
    " Selected or cancelled?
    let [s:item,s:got_it,s:result] = [ "", 0, a:result ]
    if s:result > 0 && s:result <= len(s:current_buffer_list)
        let [s:item,s:got_it] = [s:current_buffer_list[s:result - 1], 1]
    endif
    " Exit if cancelled.
    if !s:got_it
        7PRINT! p:0.5:hl:lbgreen2:The operation has been correctly canceled.
        return
    endif
    
    let s:mres = matchlist( s:item,'^\s*\(\d\+\)u\=\s*\%([^[:space:]]\+\)\=\s\++\=\s*"\([^"]\+\)"\s\+.*' )
    if empty(s:mres)
        7PRINT! p:0.5:hl:0:Error: Couldn't parse the buffer listing.
        return
    else
        exe "buf" s:mres[1]
        7PRINT! p:0.5:hl:bluemsg:Switched to the buffer: ('«'.s:mres[2].'»')
    endif
endfunc
" }}}

" FUNCTION: UserMenu_ProvidedKitFuns_JumpSelectionPopup() {{{
func! UserMenu_ProvidedKitFuns_JumpSelectionPopup()
    hi! UMPmenuJL ctermfg=lightyellow ctermbg=22
    hi! UMPmenuJLSB ctermfg=51 ctermbg=darkblue
    hi! UMPmenuJLTH ctermfg=51 ctermbg=darkblue
    hi! PopupSelected ctermfg=17 ctermbg=82
    hi! PmenuSel ctermfg=17 ctermbg=82

    let s:current_jump_list = split(execute('jumps'),"\n")[1:]
    call popup_menu(s:current_jump_list, #{
                \ callback:'UserMenu_ProvidedKitFuns_JumpSelectionCallback',
                \ time: 30000,
                \ mapping: 0,
                \ border: [ ],
                \ fixed: 1,
                \ wrap: 0,
                \ maxheight: &lines-10,
                \ maxwidth: &columns-20,
                \ flip: 1,
                \ title: ' VIM User Menu ≈ Select The Position To Jump To: ≈ ',
                \ drag: 1,
                \ resize: 0,
                \ close: 'button',
                \ highlight: 'UMPmenuJL',
                \ scrollbar: 1,
                \ scrollbarhighlight: 'UMPmenuJLSB',
                \ thumbhighlight: 'UMPmenuJLTH',
                \ cursorline: 1,
                \ borderhighlight: [ 'um_gold', 'um_gold', 'um_gold', 'um_gold' ],
                \ padding: [ 2, 2, 2, 2 ] } )
endfunc
" }}}
" FUNCTION: UserMenu_ProvidedKitFuns_JumpSelectionCallback() {{{
func! UserMenu_ProvidedKitFuns_JumpSelectionCallback(id, result)
    " Selected or cancelled?
    let [s:item,s:got_it,s:result] = [ "", 0, a:result ]
    if s:result > 0 && s:result <= len(s:current_jump_list)
        let [s:item,s:got_it] = [s:current_jump_list[s:result - 1], 1]
    endif
    " Exit if cancelled.
    if !s:got_it
        7PRINT! p:0.5:hl:lbgreen2:The operation has been correctly canceled.
        return
    endif
    
    let s:curjump = -1
    " 1-based ↔ adapted to a:result
    let idx = 1
    for jump in s:current_jump_list
        if jump =~ '^\s*>.*$'
            let s:curjump = idx
            break
        endif
        let idx += 1
    endfor
    let s:j = s:result - s:curjump
    let s:mres = matchlist( s:item,'^\s*\%(\d\+\s\+\)\{3}\(.\+\)$' )
    let s:mres = empty(s:mres) ? ["",""] : s:mres
    if s:j < 0
        execute "normal " . (-s:j) . "\<c-o>"
        7PRINT! p:0.2:hl:bluemsg:Jumped (-s:j) positions back \(^O) to: ('«'.s:mres[1].'».')
    elseif s:j > 0
        execute "normal " . s:j . "\<c-i>"
        7PRINT! p:0.2:hl:bluemsg:Jumped s:j positions forward \(Tab) to: ('«'.s:mres[1].'».')
    else
        7PRINT! p:0.5:hl:bluemsg:Already at the position.
    endif
endfunc
" }}}

"""""""""""""""""" THE END OF THE IN-MENU USE FUNCTIONS }}}

" vim:set ft=vim tw=80 foldmethod=marker:
