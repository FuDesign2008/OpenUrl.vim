"
" openUrl.vim
"
" avalable for win32, mac, unix/linux
"
" 1. Open the url under the cursor: <leader>ou
" 2. Open the github bundle under the cursor: <leader>ob
"
"



if &cp || exists("g:open_url")
    finish
endif
let g:open_url = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:OpenUrl(url)
    if a:url != ""
        " open url from shell command line
        " @see http://www.dwheeler.com/essays/open-files-urls.html
        "
        if has('win32')
            silent exec "!cmd /c start " . a:url
            echomsg 'open url "' . a:url . '" ...'
        elseif has('mac')
            silent exec "!open '". a:url ."'"
            echomsg 'open url "' . a:url . '" ...'
        elseif has('unix')
            " unix/linux
            silent exec "!xdg-open '". a:url ."'"
            echomsg 'open url "' . a:url . '" ...'
        else
            echomsg 'Url "' . a:url . '" can NOT be opened!'
        endif
    endif
endfunction

function! OpenUrlUnderCursor()
    "One line may have more than one url
    "let url = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
    execute "normal BvEy"
    let url = matchstr(@0, '[a-z]*:\/\/[^ >,;)"]*')
    if strlen(url)
        call s:OpenUrl(url)
    else
        echomsg 'Url is not found!'
    endif
endfunction

function! OpenBundleUnderCursor()
    let bundle = expand('<cfile>')
    if strlen(bundle)
        call s:OpenUrl('https://github.com/' . bundle)
    else
        echomsg 'Bundle address is not found!'
    endif
endfunction


noremap <leader>ou :call OpenUrlUnderCursor()<CR>
noremap <leader>ob :call OpenBundleUnderCursor()<CR>


let &cpo = s:save_cpo
