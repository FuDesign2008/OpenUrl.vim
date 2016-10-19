OpenUrl.vim
===========

Open url under cursor!

NOTE: You can also open the url under cursor with `gx`, executing `:help
netrw-gx` to see more.

## Commands
* `OpenUrl`: open the url under cursor, default key map `<leader>u`
* `OpenBundle`: open the github bundle under cursor, default key map `<leader>b`
* `OpenJira`: open the jira item under cursor, default key map `<leader>j`


## Config

* `g:open_url_custom_keymap`. This option is used to config the key mappings. If you want to custom the key mappings, set the option to `1`. The default value is `0`
* `g:jira_url_prefix`: The prefix url of jira item

## Next
1. to highlight url
