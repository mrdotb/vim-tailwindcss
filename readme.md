vim-tailwindcss
=========

simple tailwindcss class completion in Vim using a 'completefunc'

Installation
------------

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'mrdotb/vim-tailwindcss'
```

Examples
--------

### Class completion

```vim
" Set the completefunc you can do this per file basis or with a mapping
set completefunc=tailwind#complete
" The mapping I use
nnoremap <leader>tt :set completefunc=tailwind#complete<cr>
" Add this autocmd to your vimrc to close the preview window after the completion is done
autocmd CompleteDone * pclose
```

[preview](https://raw.githubusercontent.com/mrdotb/i/master/demo-vim-tailwindcss.gif)
