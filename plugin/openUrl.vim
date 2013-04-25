"
" openUrl.vim
"
" avalable for win32, mac, unix/linux
"
" 1. Open the url under the cursor: <leader>u
" 2. Open the github bundle under the cursor: <leader>b
"
"



if &cp || exists("g:open_url")
    finish
endif
let g:open_url = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:OpenUrl(url)
    if strlen(a:url)
        " open url from shell command line
        " @see http://www.dwheeler.com/essays/open-files-urls.html
        let urlStr = a:url
        " replace # with \#, or else # will be replace with alternative file
        " in vim
        let urlStr = substitute(urlStr, '#', '\\#', '')
        if has('win32') || has('win64')
            silent exec '!cmd /c start "" "' . urlStr . '"'
            echomsg 'open url "' . urlStr . '" ...'
        elseif has('mac')
            silent exec "!open '". urlStr ."'"
            echomsg 'open url "' . urlStr . '" ...'
        elseif has('unix')
            " unix/linux
            silent exec "!xdg-open '". urlStr ."'"
            echomsg 'open url "' . urlStr . '" ...'
        else
            echomsg 'Url "' . urlStr . '" can NOT be opened!'
        endif
    endif
endfunction


function! OpenUrlUnderCursor()
    "One line may have more than one url
    "let url = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
    execute "normal BvEy"
    " \u0027 = '
    let url = matchstr(@0, '[a-z]*:\/\/[^ >,;)"\u0027]*')
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


noremap <leader>u :call OpenUrlUnderCursor()<CR>
noremap <leader>b :call OpenBundleUnderCursor()<CR>


let &cpo = s:save_cpo
