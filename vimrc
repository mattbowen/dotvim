if has("gui_running")
  set anti enc=utf-8
  set guioptions=M
  set guifont=Source\ Code\ Pro\ for\ Powerline:h14
endif

if has("gui_macvim") || has("gui_vimr")
  set guifont=Source\ Code\ Pro\ for\ Powerline:h14
endif

if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

if $COLORTERM == 'screen'
  set t_Co=256
endif

" Needed for vundle
filetype off

"
set background=dark
set clipboard=unnamed
set backspace=2   " Backspace deletes like most programs in insert mode
syn on comment minlines=10 maxlines=1000
filetype plugin indent on
set encoding=utf-8
set expandtab
set smarttab
set shiftround
set incsearch
set hlsearch
set ignorecase
set smartcase
set showmatch
set title
set hidden
set history=1000
set wildignore+=*.sw*,*.pyc,*.class,*.o
set wildmenu
set wildmode=list:longest
set noerrorbells
set ruler
set laststatus=2
set number
set autowrite     " Automatically :write before running commands
set complete+=kspell
" Keyboard timeout quicker to show mode line changes
set ttimeoutlen=100

" Printer options
set pdev=pdf
set printoptions=paper:letter,syntax:y,wrap:y

" Don't try to save a swap to current dir until last resort
set directory=~/tmp,/var/tmp,/tmp,.

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

let mapleader = ","

" Let me make empty directories when I save
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

set list
" how i want to display tabs and trailing whitespace
set listchars=tab:>-,trail:·
",eol:$
" toggle displaying the trailing characters
nmap <silent> <leader>s :set nolist!<CR>

" clear the current highlighted search
nnoremap <leader><space> :noh<cr>

" select the lines from the previous paste using the [] marks
nmap <leader>p `[v`]

" Convert a search into folds
" From http://vim.wikia.com/wiki/Folding_with_Regular_Expression
nnoremap <localleader>z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>
" Delete the folds set by \z
nnoremap <localleader>Z :setlocal foldcolumn=0 foldexpr=<CR>
" Make a new command Foldsearch that searches and folds
command! -nargs=+ Foldsearch exe "normal /".<q-args>."\z"

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Enable tagbar toggle shortcut
nmap <F8> :TagbarToggle<CR>

set pastetoggle=<F2>

" Define custom extentions for filetype
augroup FileTypes
autocmd!
autocmd BufNewFile,BufRead *.module,*.inc setfiletype php
autocmd BufNewFile,BufRead *.zcml setfiletype xml
augroup END

augroup Indents
autocmd!
autocmd FileType php set cindent sw=2 ts=2 softtabstop=2
autocmd FileType perl set cindent sw=4 ts=4 softtabstop=4
autocmd FileType plsql set sw=2 ai cindent
autocmd FileType xml set sw=2 ts=2 softtabstop=2
autocmd FileType html set sw=2 ts=2 softtabstop=2
autocmd FileType javascript set sw=2 ts=2 softtabstop=2 cindent
augroup END
" Python {{{
augroup Python
set colorcolumn=121
autocmd!
" I normally keep tabstop and softtabstop identical, but since Python
" sees actual tab characters as 8 always, show them as that.
autocmd FileType python setlocal foldmethod=indent foldnestmax=2 ts=8 expandtab sw=4 softtabstop=4
augroup END
" }}}

" ReStructuredText {{{

" Do ReStructuredText-style sections over and underlining. Non-shifted is
" just underlining, shifted is over and under.
au Filetype rst,markdown,python nnoremap <buffer> <localleader>! yypVr#yykPjj:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>1 yypVr#:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>@ yypVr*yykPjj:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>2 yypVr*:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader># yypVr=yykPjj:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>3 yypVr=:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>$ yypVr-yykPjj:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>4 yypVr-:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>% yypVr^yykPjj:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>5 yypVr^:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>^ yypVr"yykPjj:redraw<cr>
au Filetype rst,markdown,python nnoremap <buffer> <localleader>6 yypVr":redraw<cr>
autocmd BufRead,BufNewFile *.rst setlocal spell
augroup ft_rest
    au!

    au FileType rst set sw=4 ts=4 softtabstop=4
augroup END

" }}}

" Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/vundle'

" Bundles here:
"
" original repos on github
Plugin 'bling/vim-airline'
Plugin 'bilalq/lite-dfm'
Plugin 'bogado/file-line'
Plugin 'elzr/vim-json'
Plugin 'flazz/vim-colorschemes'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'mbbill/undotree'
Plugin 'mhinz/vim-signify'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-vinegar'
Plugin 'scrooloose/syntastic'
Plugin 'strange/strange.vim'
Plugin 'wellsjo/wells-colorscheme.vim'
Plugin 'wting/rust.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Valloric/YouCompleteMe'
Plugin 'luochen1990/rainbow'
Plugin 'ajh17/Spacegray.vim'
Plugin 'szw/vim-ctrlspace'
Plugin 'mtth/scratch.vim'
Plugin 'terryma/vim-multiple-cursors'

" vim-scripts repos
Plugin 'matchit.zip'
Plugin 'python_match.vim'
Plugin 'psql.vim'
Plugin 'csv.vim'

" non github repos
"Plugin 'git://git.wincent.com/command-t.git'
"
" Brief help
" :PluginList          - list configured bundles
" :PluginInstall(!)    - install(update) bundles
" :PluginSearch(!) foo - search(or refresh cache first) for foo
" :PluginClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ

filetype plugin indent on
set ai

" JSON {{{
augroup JSON
autocmd!
autocmd BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead *.jsonp set filetype=json
autocmd FileType json nnoremap <buffer> <localleader>j :%!python -m json.tool<CR>:%s/\s\+$//<CR>
augroup END
" }}}

" Markdown {{{
augroup Markdown
  autocmd!
  autocmd BufNewFile,BufRead *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.md setlocal spell
  au FileType rst set sw=4 ts=4 softtabstop=4
augroup END
" }}}

" Color scheme settings
"colorscheme wombat256mod
"colorscheme wells-colors
colorscheme Spacegray
highlight clear SignColumn

" CtrlP Settings
let g:ctrlp_cmd='CtrlPMixed'  " Search everything by default
let g:ctrlp_root_markers = ['.ctrlp'] " Enable .ctrlp to mark top for ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard']

" netrw config
" I had some deleted config from, instead I'm using vim-vinegar now.
" from http://modal.us/blog/2013/07/27/back-to-vim-with-nerdtree-nope-netrw/
" and
" http://ellengummesson.com/blog/2014/02/22/make-vim-really-behave-like-netrw/

" Strip the newline from the end of a string
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction

" Surround settings
" Enable C-style commenting out with *
let b:surround_42 = "/* \r */"

vmap <leader>c gS*

" Write a file using sudo in case you opened it as not root
command Sudo :%!sudo tee > /dev/null %

" syntastic options
let g:syntastic_check_on_open=1
let g:syntastic_error_symbol='✗'
let g:syntastic_enable_highlighting=0
let g:syntastic_python_checkers=['python', 'flake8']

" undotree options
nnoremap <F5> :UndotreeToggle<CR>

" highlight lines in Sy and vimdiff etc.)

highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
highlight DiffChange        cterm=bold ctermbg=none ctermfg=227

" highlight signs in Sy

highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227

" vim-airline configuration
" Turn on the buffer/tab list
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':~:.'
let g:airline_powerline_fonts = 1
" Disable seperator pieces
"let g:airline_symbols = {}
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''

" lite-dfm options {{{
let g:lite_dfm_left_offset = 4
nnoremap <leader>z :LiteDFMToggle<CR>i<Esc>`^
" }}}

" basic easymotion setup until I get the hang of it
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Rainbow! For easier-to-see parens
let g:rainbow_active = 1

" Powerline shell, because ZSH makes a mess for me
let g:promptline_theme = 'airline'

" CntrlSpace
let g:airline_exclude_preview = 1
let g:ctrlspace_project_root_markers=['.ctrlp', '.git']
"let g:ctrlspace_default_mapping_key=<leader> <C-t>

" Python-mode
" Disable rope completion to keep Jedi
let g:ropevim_vim_completion=0
