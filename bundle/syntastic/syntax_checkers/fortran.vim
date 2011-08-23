"============================================================================
"File:        fortran.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Karl Yngve Lervåg <karl.yngve@lervag.net>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
if exists("loaded_fortran_syntax_checker")
    finish
endif
let loaded_fortran_syntax_checker = 1

"bail if the user doesnt have fortran installed
if !executable("gfortran")
    finish
endif

function! SyntaxCheckers_fortran_GetLocList()
    let makeprg = 'gfortran -fsyntax-only ' . shellescape(expand('%')) . '  '
    let makeprg = 'gfortran -I../objects/debug_gfortran_Linux -fsyntax-only ' . shellescape(expand('%'))
    let errorformat =  '%E%f:%l.%c:,%-G%p^,%ZError: %m'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction
