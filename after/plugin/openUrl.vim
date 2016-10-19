"
" openUrl.vim
"
" available for windows, mac, unix/linux
"
" 1. Open the url under the cursor: <leader>u
" 2. Open the github bundle under the cursor: <leader>b
"
"



if &cp || exists('g:open_url')
    finish
endif
let g:open_url = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:OpenUrl(url)
    if strlen(a:url)
        " open url from shell command line
        " @see http://www.dwheeler.com/essays/open-files-urls.html
        let urlStr = shellescape(a:url)
        let cmdStr = ''

        if has('win32') || has('win64')
            let cmdStr = 'cmd /c start "" ' . urlStr
        elseif has('mac')
            let cmdStr = 'open -a Safari ' . urlStr
            let findStr = system('ls /Applications/ | grep -i google\ chrome')
            let findStrLocal = system('ls ~/Applications/ | grep -i google\ chrome')
            if strlen(findStr) > 5 || strlen(findStrLocal) > 5
                let cmdStr = 'open -a Google\ Chrome ' . urlStr
            endif
        elseif has('unix')
            " unix/linux
            let cmdStr = 'xdg-open ' . urlStr
        else
            echomsg 'Url "' . urlStr . '" can NOT be opened!'
            return
        endif

        call system(cmdStr)
        echomsg cmdStr

    endif
endfunction

"@param {String} str
"@param {String} start
"@return {Boolean}
function! s:InsensiveStartWith(str, start)
    return stridx(tolower(a:str), tolower(a:start)) == 0
endfunction


function! s:OpenUrlUnderCursor()
    "One line may have more than one url
    execute 'normal BvEy'
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
    let text = @0
    " mailto:
    let url = matchstr(text, '\(mailto:\)\?[A-Za-z0-9\.\-;:&=+\$,\w~%\/\!?#_]\+@[A-Za-z0-9\.\-;:&=+\$,\w~%\/\!?#_]\+')
    if s:InsensiveStartWith(url, 'mailto:')
        "do nothing
    elseif strlen(url)
        let url = 'mailto:' . url
    else
        let url = ''
    endif
    if !strlen(url)
        " http://
        " file:///
        let url = matchstr(text, '[A-Za-z]\{3,9\}:\(\/\{2,3\}\)\?[A-Za-z0-9\.\-;:&=+\$,\w~%\/\!?#_]\+')
        if !strlen(url)
            "www.
            let url = matchstr(text, 'www\.[A-Za-z0-9\.\-;:&=+\$,\w~%\/\!?#_]\+')
            if strlen(url)
                let url = 'http://' . url
            endif
        endif
    endif
    "echo text
    "echo url
    "return

    if strlen(url)
        call s:OpenUrl(url)
    else
        echomsg 'Url is not found!'
    endif
endfunction

function! s:OpenBundleUnderCursor()
    let bundle = expand('<cfile>')
    if strlen(bundle)
        call s:OpenUrl('https://github.com/' . bundle)
    else
        echomsg 'Bundle address is not found!'
    endif
endfunction


function! s:OpenJiraItemUnderCursor()

    if !exists('g:open_jira_prefix')
        echomsg 'g:open_jira_prefix does NOT exist, config it at .vimrc'
        return
    endif

    let line = getline('.') . ''
    let index = col('.')
    let reg = '\a\+-\d\+'

    let jiraItem = ''
    let startIndex = 0
    let result = matchstrpos(line, reg, startIndex)
    let matchStart = result[1]
    let matchEnd = result[2]

    while matchStart != -1

        if matchStart >= index && index <= matchEnd
            let jiraItem = result[0]
            break
        end

        let startIndex = matchEnd
        let result = matchstrpos(line, reg, startIndex)
        let matchStart = result[1]
        let matchEnd = result[2]
    endwhile

    if strlen(jiraItem) < 3
        return
    endif

    let prefix = g:open_jira_prefix
    if !matchstr(prefix, '/$')
        let prefix = prefix . '/'
    endif

    let fullUrl = prefix . jiraItem
    call s:OpenUrl(fullUrl)
endfunction

command -nargs=0 OpenUrl call s:OpenUrlUnderCursor()
command -nargs=0 OpenBundle call s:OpenBundleUnderCursor()
command -nargs=0 OpenJira call s:OpenJiraItemUnderCursor()


if !exists('g:open_url_custom_keymap')
    nnoremap <leader>u OpenUrl<CR>
    nnoremap <leader>b OpenBundle<CR>
    nnoremap <leader>j OpenJira<CR>
endif


let &cpo = s:save_cpo
