" Script variables

" s:aulist  - events to log    {{{1
""
" Autocmd events to log.
"
" The following autocmds are deliberately not logged because of side effects:
" - SourceCmd
" - FileAppendCmd
" - FileWriteCmd
" - BufWriteCmd
" - FileReadCmd
" - BufReadCmd
" - FuncUndefined
let s:aulist = [
            \ 'BufAdd',               'BufCreate',
            \ 'BufDelete',            'BufEnter',
            \ 'BufFilePost',          'BufFilePre',
            \ 'BufHidden',            'BufLeave',
            \ 'BufNew',               'BufNewFile',
            \ 'BufRead',              'BufReadPost',
            \ 'BufReadPre',           'BufUnload',
            \ 'BufWinEnter',          'BufWinLeave',
            \ 'BufWipeout',           'BufWrite',
            \ 'BufWritePost',         'BufWritePre',
            \ 'CmdUndefined',         'CmdwinEnter',
            \ 'CmdwinLeave',          'ColorScheme',
            \ 'CompleteDone',         'CursorHold',
            \ 'CursorHoldI',          'CursorMoved',
            \ 'CursorMovedI',         'EncodingChanged',
            \ 'FileAppendPost',       'FileAppendPre',
            \ 'FileChangedRO',        'FileChangedShell',
            \ 'FileChangedShellPost', 'FileReadPost',
            \ 'FileReadPre',          'FileType',
            \ 'FileWritePost',        'FileWritePre',
            \ 'FilterReadPost',       'FilterReadPre',
            \ 'FilterWritePost',      'FilterWritePre',
            \ 'FocusGained',          'FocusLost',
            \ 'GUIEnter',             'GUIFailed',
            \ 'InsertChange',         'InsertCharPre',
            \ 'InsertEnter',          'InsertLeave',
            \ 'MenuPopup',            'QuickFixCmdPost',
            \ 'QuickFixCmdPre',       'QuitPre',
            \ 'RemoteReply',          'SessionLoadPost',
            \ 'ShellCmdPost',         'ShellFilterPost',
            \ 'SourcePre',            'SpellFileMissing',
            \ 'StdinReadPost',        'StdinReadPre',
            \ 'SwapExists',           'Syntax',
            \ 'TabEnter',             'TabLeave',
            \ 'TermChanged',          'TermResponse',
            \ 'TextChanged',          'TextChangedI',
            \ 'User',                 'VimEnter',
            \ 'VimLeave',             'VimLeavePre',
            \ 'VimResized',           'WinEnter',
            \ 'WinLeave',
            \ ]

" s:logfile - path of log file    {{{1

""
" Log file path.
"
" Can be set from variable g:dn_autocmds_log or by command
" @command(AutocmdsLogFile). Otherwise defaults to file named
" "vim-autocmds-log" in the user's home directory.
let s:logfile = ''

" s:enabled - logging status    {{{1

""
" Autocmd logging status.
"
" Whether autocmd event logging is currently enabled.
let s:enabled = 0
" }}}1

" Script functions

" s:error(message)    {{{1

""
" @private
" Display error message.
function! s:error(message) abort
    echohl Error
    echomsg a:message
    echohl Normal
endfunction

" s:log(message)    {{{1

""
" @private
" Write a message to the autocmd events log file.
function! s:log(message) abort
    let l:msg = strftime('%T', localtime()) . ' - ' . a:message
    call writefile([l:msg], s:logfile, 'a')
endfunction
" }}}1

" Private functions

" dn#log_autocmds#_toggle()    {{{1

""
" @private
" Toggle autocmds logging on and off. Writes a timestamped message to the log
" file.
function! dn#log_autocmds#_toggle() abort
    augroup LogAutocmd
        autocmd!
    augroup END

    let l:date = strftime('%F', localtime())
    let l:abort_enable = 0

    try
        if s:enabled  " stop logging
            echomsg 'Log file is ' . s:logfile
            echomsg 'Autocmd event logging is DISABLED'
            try
                call s:log('Stopped autocmd log (' . l:date . ')')
            catch
            endtry
        else  " start logging
            if empty(s:logfile)  " can't log without logfile!
                throw 'No log file path has been set'
            endif
            try
                call s:log('Started autocmd log (' . l:date . ')')
            catch
                let l:abort_enable = 1
                throw v:exception
            endtry
            echomsg 'Autocmd event logging is ENABLED'
            echomsg 'Log file is ' . s:logfile
            augroup LogAutocmd
                for l:au in s:aulist
                    silent execute 'autocmd' l:au
                                \ '* call s:log(''' . l:au . ''')'
                endfor
            augroup END
        endif
    catch
        call s:error(v:exception)
    finally  " toggle logging status
        if l:abort_enable
            call s:error('Unable to enable autcmds event logging')
        else
            let s:enabled = get(s:, 'enabled', 0) ? 0 : 1
        endif
    endtry
endfunction

" dn#log_autocmds#_status()    {{{1

""
" @private
" Display status of autocmds event logging and the log file path.
function! dn#log_autocmds#_status() abort
    " display logging status
    let l:status = (s:enabled) ? 'ENABLED' : 'DISABLED'
    echomsg 'Autocmds event logging is ' . l:status
    " display logfile
    let l:path = (s:logfile) ? 'not set' : s:logfile
    echomsg 'Log file is ' . l:path
endfunction

" dn#log_autocmds#_logfile(path)    {{{1

""
" @private
" Log future autocmd events and notes to file {path}.
" If {path} is the name of the current log file, the function has no
" effect. If the plugin is currently logging to a different file, that file is
" closed and the new log file opened.
" If the {path} is invalid or unwritable an error will occur when the plugin
" next attempts to write to the log. If logging is enabled when this function
" is invoked, the plugin tries to write to the file immediately with a
" timestamped message recording the time of logging activation.
function! dn#log_autocmds#_logfile(path) abort
    " return if no path provided
    if empty(a:path)
        call s:error('No log file path provided')
        return
    endif
    " no action required if log file path already set to this value
    let l:path = simplify(resolve(fnamemodify(a:path, ':p')))
    if !empty(s:logfile) && l:path ==# s:logfile
        return
    endif
    " okay, set logfile path
    let l:enabled = s:enabled
    if l:enabled
        call dn#log_autocmds#_toggle()
    endif
    let s:logfile = l:path
    if l:enabled
        call dn#log_autocmds#_toggle()
    endif
endfunction

" dn#log_autocmds#_annotate(message)    {{{1

""
" @private
" Write message to log file. Requires autocmd event logging to be enabled; if
" it is not, an error message is displayed.
function! dn#log_autocmds#_annotate(message) abort
    " return if no message provided
    if empty(a:message)
        call s:error('No log message provided')
        return
    endif
    " display error if not currently logging
    if !s:enabled
        call s:error('Autocmd event logging is not enabled')
        return
    endif
    " log message
    call s:log(a:message)
endfunction

" dn#log_autocmds#_delete()    {{{1

""
" @private
" Delete log file if it exists.
function! dn#log_autocmds#_delete() abort
    if s:enabled
        call dn#log_autocmds#_toggle()
    endif
    if filewritable(s:logfile)
        let l:result = delete(s:logfile)
        let l:errors = []
        if l:result != 0
            call add(l:errors, 'Operating system reported delete error')
        endif
        if filewritable(s:logfile)
            call add(l:errors, 'Log file was not deleted')
        endif
        if empty(l:errors)  " presume success
            echomsg 'Deleted ' s:logfile
        else  " there were problems
            call insert(l:errors, 'Log file: ' . s:logfile)
            call s:error(join(l:errors, "\n"))
        endif
    else  " can't find writable log file, so presume doesn't exist
        echomsg "Can't find " . s:logfile . ' to delete'
    endif
endfunction
" }}}1

" vim: set foldmethod=marker :