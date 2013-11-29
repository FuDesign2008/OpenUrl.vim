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
    execute "normal BvEy"
    " uri specification
    " @see http://tools.ietf.org/html/rfc3986#section-3.1
    "
    "        foo://example.com:8042/over/there?name=ferret#nose
    "        \_/   \______________/\_________/ \_________/ \__/
    "         |           |            |            |        |
    "      scheme     authority       path        query   fragment
    "         |   _____________________|__
    "        / \ /                        \
    "        urn:example:animal:ferret:nose
    "
    "
    "
    "@see http://blog.mattheworiordan.com/post/13174566389/url-regular-expression-for-links-with-or-without-the
    "
    let url = matchstr(@0, '[A-Za-z]{3,9}*:(\/{2,3})?[A-Za-z0-9\.\-;:&=\+\$,\w~%\/@\!]+')

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


if !exists('g:open_url_custom_keymap')
    nnoremap <leader>u :call OpenUrlUnderCursor()<CR>
    nnoremap <leader>b :call OpenBundleUnderCursor()<CR>
endif


let &cpo = s:save_cpo
