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
    echomsg 'Error: ' . a:message
    echohl Normal
endfunction

" s:log(message)    {{{1

""
" @private
" Write a {message} or messages to the autocmd events log file. Accepts a
" single string or list of strings.
" @throws CantCreateFile if invalid logfile
function! s:log(message) abort
    " process args
    " - message can't be empty
    if empty(a:message)
        call s:error('Empty message sent for writing to log')
        return
    endif
    " - handle multiple messages; assume end up with list of strings
    let l:messages = []
    if   type(a:message) == v:t_string | call add(l:messages, a:message)
    else                               | call extend(l:messages, a:message)
    endif
    " add date-time message prefix if strftime() is available
    let l:format = '%Y-%m-%d %H:%M:%S'
    let l:prefix = exists('*strftime') ? strftime(l:format) . ' - '
                \                      : ''
    let l:entries = map(l:messages, 'l:prefix . v:val')
    " write messages
    " - writefile() throws error and exits function if invalid filepath, but
    "   just in case throw manual error if error code returned by writefile()
    let l:result = writefile(l:entries, s:logfile, 'a')
    if l:result != 0 | throw 'Autocmds log write operation failed' | endif
endfunction

" s:log_or_disable(message)    {{{1

""
" @private
" If exception thrown by write operation, disable log writing.
function! s:log_or_disable(message) abort
    try
        call s:log(a:message)
    catch
        call s:error(s:exception_error(v:exception))
        call dn#log_autocmds#_disable(1)  " disable without log write
    endtry
endfunction

" s:exception_error(exception)    {{{1

""
" @private
" Extracts error message from Vim exceptions. Other exceptions are returned
" unaltered.
"
" This is useful because vim will not allow Vim errors to be re-thrown. If all
" errors are processed by this function before re-throwing them, there is no
" chance of the re-throw causing this failure.
"
" It also makes the errors a little more easy to read since the Vim context is
" removed. (This context provides little troubleshooting assistance in simple
" scripts.) For that reason this function may usefully be used in processing
" all exceptions before operating on them.
function! s:exception_error(exception) abort
    let l:matches = matchlist(a:exception,
                \ '^Vim\%((\a\+)\)\=:\(E\d\+\p\+$\)')
    return (!empty(l:matches) && !empty(l:matches[1])) ? l:matches[1]
                \                                      : a:exception
endfunction
" }}}1

" Private functions

" dn#log_autocmds#_toggle()    {{{1

""
" @private
" Toggle autocmds logging on and off.
function! dn#log_autocmds#_toggle() abort
    if   s:enabled | call dn#log_autocmds#_disable()
    else           | call dn#log_autocmds#_enable()
    endif
endfunction

" dn#log_autocmds#_enable()    {{{1

""
" @private
" Enable autocmds event logging. Writes a timestamped message to the log file
" and displays user feedback.
function! dn#log_autocmds#_enable() abort
    " clear previously set autocmds
    augroup LogAutocmd
        autocmd!
    augroup END

    " don't set flag to true until log file is successfully written to
    let s:enabled = 0

    " can't log without logfile!
    if empty(s:logfile)
        call s:error('Cannot enable logging -- log file path is not set')
        return
    endif

    " write log message
    try
        call s:log([repeat('*', 40), 'Started autocmd event logging'])
    catch
        call s:error(s:exception_error(v:exception))
        return
    endtry

    " successful write to log so: set flag, give feedback, and set autocmds
    let s:enabled = 1

    echomsg 'Autocmd event logging is ENABLED'
    echomsg 'Log file is ' . s:logfile

    augroup LogAutocmd
        for l:au in s:aulist
            silent execute 'autocmd' l:au
                        \ '* call s:log_or_disable(''' . l:au . ''')'
        endfor
    augroup END
endfunction

" dn#log_autocmds#_disable()    {{{1

""
" @private
" Toggle autocmds logging on and off.
"
" Writes a timestamped message to the log file unless [suppress_write] is
" present and true, i.e., default is to write log.
" @default suppress_write=false
function! dn#log_autocmds#_disable(...) abort
    " process args
    " - note logic flip from suppress_write to write_log
    let l:write_log = (a:0 && a:1) ? 0 : 1

    " clear previously set autocmds
    augroup LogAutocmd
        autocmd!
    augroup END

    " set flag to false
    let s:enabled = 0

    " write log if required, ignoring any errors
    if l:write_log
        try
            call s:log(['Stopped autocmd event logging', repeat('*', 40)])
        catch
        endtry
    endif

    " provide feedback
    echomsg 'Log file is ' . s:logfile
    echomsg 'Autocmd event logging is DISABLED'
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
    " log message, disabling logging on write error
    call s:log_or_disable(a:message)
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
