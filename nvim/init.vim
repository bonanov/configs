let mapleader=" "

" for some reasons polyglot is very slow. TODO: test it
let g:polyglot_disabled = ['javascript.plugin', 'vue.plugin']

if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif


let g:VM_no_meta_mappings = 1

" mappings for multi cursor
let g:VM_maps = {}
let g:VM_maps["Select All"]        = '<leader>a'
let g:VM_maps["Visual All"]        = '<leader>a'
let g:VM_maps["Align"]             = '<leader>A'
let g:VM_maps["Add Cursor Down"]   = '<C-j>'
let g:VM_maps["Add Cursor Up"]     = '<C-k>'
let g:VM_leader = "\\"
" select words with Ctrl-N (like Ctrl-d in Sublime Text/VS Code)
" create cursors vertically with Ctrl-j/Ctrl-k
" press q to skip current and get next occurrence
" press Q to remove current cursor/selection
" start insert mode with i,a,I,A

call plug#begin()
Plug 'tpope/vim-dispatch'
Plug 'metakirby5/codi.vim'

Plug 'thaerkh/vim-workspace'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'machakann/vim-highlightedyank'
" Plug 'psliwka/vim-smoothie'
Plug 'chriskempson/base16-vim'


" Smooth osscroll
Plug 'tomtom/tcomment_vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
" Plug 'jiangmiao/auto-pairs'

" FuzzyFinder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" YEP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" NERDTree
" Plug 'preservimsnerdtree'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'sheerun/vim-polyglot'
" Plug 'jelera/vim-javascript-syntax'
Plug 'scrooloose/nerdcommenter'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" Status Line
" Plug 'itchyny/lightline.vim'
" Schemas
Plug 'joshdick/onedark.vim'
" Plug 'ryanoasis/vim-devicons'
Plug 'lambdalisue/nerdfont.vim'

Plug 'sainnhe/edge'
Plug 'AlessandroYorba/Sierra'
Plug 'tomasiser/vim-code-dark'
Plug 'scrooloose/syntastic'
Plug 'rishikanthc/skyfall-vim'

Plug 'vimwiki/vimwiki'
Plug 'rainglow/vim'

" neovim in browser
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'jiangmiao/auto-pairs'
call plug#end()

let g:highlightedyank_highlight_duration = 100

let g:syntastic_rust_checkers = ['rustc']

" let g:NERDTreeMapMenu = 'b'


if (has("termguicolors"))
  set termguicolors
endif

" Add/remove bookmark at current line	                mm
" Add/edit/remove annotation at current line	        mi
" Jump to next bookmark in buffer	                mn
" Jump to previous bookmark in buffer	                mp
" Show all bookmarks (toggle)	                        ma
" Clear bookmarks in current buffer only	        mc
" Clear bookmarks in all buffers	                mx
" Move up bookmark at current line	                [count]mkk
" Move down bookmark at current line	                [count]mjj
" Move bookmark at current line to another line	        [count]mg
" Save all bookmarks to a file		                :BookmarkSave <FILE_PATH>
" Load bookmarks from a file                            :BookmarkLoad <FILE_PATH>
let g:bookmark_sign = '♥'
let g:bookmark_highlight_lines = 1
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]




" au Filetype rust set colorcolumn=100
au FileType rust,vimwiki,markdown set shiftwidth=4
au FileType rust,vimwiki,markdown set softtabstop=4
au FileType rust,vimwiki,markdown set tabstop=4
au FileType rust,vimwiki,markdown set expandtab

au FileType python set shiftwidth=4
au FileType python set softtabstop=4
au FileType python set tabstop=4
au FileType python set expandtab

au FileType typescript,javascript set shiftwidth=4
au FileType typescript,javascript set softtabstop=4
au FileType typescript,javascript set tabstop=4
au FileType typescript,javascript set expandtab
" au Filetype vimwiki,markdown set colorcolumn=200

set scrolloff=7
set mouse=a

set switchbuf=usetab
nnoremap <leader><leader> :GFiles<CR>

" Clear search selections
nnoremap <C-c> :noh<CR>
nnoremap <C-f> :!rustfmt %<CR>

" Search files by content in current folder
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --ignore --smart-case --color=always --max-columns 200 -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
nnoremap <leader>f :Rg<CR>
command! -nargs=* -bang Rgs call RipgrepFzf(<q-args>, <bang>1)

" :Sw save file as root
command! -nargs=0 Sw w !sudo tee % > /dev/null



let g:workspace_autosave_always = 1
let g:workspace_autosave = 0
let g:workspace_autosave_ignore = ['gitcommit', 'node_modules']
" Do not load workspace if explicit file provided
let g:workspace_session_disable_on_args = 1

let g:workspace_session_directory = $HOME . '/.vim/sessions/'

set undodir=~/.config/nvim/undodir
set undofile
let g:workspace_persist_undo_history = 0  " enabled = 1 (default), disabled = 0
let g:workspace_undodir='~/.config/nvim/undodir'

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfun

fun! <SID>RunRustFormat()
    :!rustfmt %
endfun

" autocmd BufWritePre *.rs call CocAction('format')

autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" syntax highlighting for buku bookmark manager
au! BufNewFile,BufRead *buku-edit* set filetype=markdown


let g:term_buf = 0
let g:term_win = 0

autocmd FileType typescript,javascript,typescriptreact,javascriptreact,vue setlocal commentstring=//\ %s


nmap <silent> <space>k :call CocAction('diagnosticNext')<CR>
nmap <silent> <space>K :call CocAction('diagnosticPrevious')<CR>
nmap <silent> gd :call CocActionAsync('jumpDefinition', 'drop')<CR>
nmap <silent> FF :call CocActionAsync('format')<CR>
nnoremap <leader> i :call CocActionAsync('codeAction', '', 'Implement missing members')<CR>

nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)

nmap <silent> gr <Plug>(coc-references)
nmap <silent> tc :tabclose<CR>
autocmd FileType python nmap <silent> yp oimport pdb; pdb.set_trace()<ESC>




" " note that if you are using Plug mapping you should not use `noremap` mappings.
" nmap <F5> <Plug>(lcn-menu)
" " Or map each action separately
" nmap <silent>K <Plug>(lcn-hover)
" nmap <silent>gd <Plug>(lcn-definition)
" nmap <Leader>rn <Plug>(lcn-rename)

nnoremap <silent> K :call <SID>show_documentation()<CR>

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" switch to last edited buffer
map <Leader>l <C-^>
" switch to next buffer
map <Leader>n :bn<cr>
" switch to prev buffer
map <Leader>p :bp<cr>
" delete buffer
map <Leader>d :bd<cr>
" list buffers
map <Leader>i :ls<CR>:b

let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline#extensions#tabline#tab_nr_type= 1
let g:airline#extensions#tabline#show_splits = 0

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Enable caching of syntax highlighting groups
let g:airline_highlighting_cache = 2
let g:airline#extensions#tabline#buffer_idx_mode = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#buffer_nr_format = '%s: '

let g:airline#extensions#hunks#enabled=1
let g:airline#extensions#branch#enabled=0
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_skip_empty_sections = 1

let g:airline_section_a = airline#section#create(['mode', 'crypt', 'paste', 'spell', 'iminsert'])

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'onedark'
let s:tabline = [ [ 'none', 'none' ] ]


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction
set hidden
set cmdheight=1
set updatetime=250
set shortmess+=c

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>qf <Plug>(coc-fix-current)
" nmap <leader>f <Plug>(coc-codeaction)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

set nocompatible

set number
set ruler

" Open NERDTree at current file or close it
" nnoremap <silent> <expr> <C-m> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : "\:NERDTreeFind<CR>"
" automatically close NerdTree when you open a file
" let NERDTreeQuitOnOpen = 1
" automatically close tab if the only remaining window is NerdTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" autocmd CursorHold * highlight Scrollbar guibg=#222222 guifg=#373f49
" Automatically delete the buffer of the file you just deleted with NerdTree:
" let NERDTreeAutoDeleteBuffer = 1
" let NERDTreeMinimalUI = 1
" let NERDTreeDirArrows = 1
set autoread
nmap <Leader>e :CocCommand explorer<CR>



" refresh file on focus
au FocusGained,BufEnter * :silent! checktime
nnoremap <C-s> :noautocmd w<CR>



vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggl

" let g:NERDTreeGitStatusWithFlags = 1
" let g:NERDTreeIgnore = ['^node_modules$']

" nmap <Leader>m <Plug>(easymotion-s)
nmap <Leader>a <Plug>(easymotion-s2)
map <Leader> <Plug>(easymotion-prefix)
" let g:EasyMotion_keys = "fjdkslaimurtcvghqpoebnwyzx"
let g:EasyMotion_keys = "xzywnbeopqhgvctrumialskdjf"

let g:EasyMotion_smartcase = 1

let g:smoothie_base_speed = 35
let g:smoothie_update_interval = 10
cnoremap $t <CR>:t''<CR>
cnoremap $T <CR>:T''<CR>
cnoremap $m <CR>:m''<CR>
cnoremap $M <CR>:M''<CR>
cnoremap $d <CR>:d<CR>``

syntax on
set t_Co=256


set background=dark
let base16colorspace=256
colorscheme onedark
" set cursorline
" colorscheme rainbow
" colorscheme codedark
" colorscheme base16-default-dark
" colorscheme base16-tomorrow-night-eighties
" colorscheme skyfall


highlight default link CocErrorSign CocDiffDelete
highlight CocErrorHighlight cterm=underline ctermfg=254 ctermbg=88 guifg=#eeeeee guibg=#FF005F gui=underline guisp=#FF0086
highlight CocWarningHighlight cterm=underline gui=underline guibg=#603020 guisp=#FF0086
highlight CocInfoHighlight cterm=undercurl gui=underline guisp=#3777E6
highlight CocHintHighlight cterm=undercurl gui=underline guisp=#3777E6
" highlight CocHintHighlight cterm=undercurl ctermbg=14 guibg=#00ffff gui=underline guisp=#1FAAAA
highlight CocHighlightRead ctermbg=238 ctermfg=250 guibg=#444444 guifg=#bcbcbc guisp=#FF0086
highlight CocHighlightText ctermbg=198 ctermfg=197 guibg=#444444 guifg=#888888 guisp=#FF0086
highlight CocHighlightWrite ctermbg=238 ctermfg=250 guibg=#444444 guifg=#bcbcbc guisp=#FF0086
highlight Search ctermfg=yellow guibg=#485663 guifg=#eeeeee
highlight Visual ctermfg=yellow guibg=#485663

highlight Normal ctermbg=none ctermfg=none guibg=none guifg=none
highlight LineNr ctermbg=none
highlight CursorLineNr ctermbg=none
highlight CursorLine ctermbg=none guibg=#282d34
highlight TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
highlight TabLine ctermfg=Blue ctermbg=Yellow
highlight TabLineSel ctermfg=Red ctermbg=Yellow
highlight Title ctermfg=LightBlue ctermbg=Magenta
" highlight ColorColumn guibg=#282d34

highlight BookmarkSign ctermbg=NONE ctermfg=160
highlight BookmarkLine ctermbg=194 ctermfg=NONE
" highlight BookmarkSign guibg=#282828 ctermbg=NONE ctermfg=160
" highlight BookmarkLine guibg=#282828 ctermbg=194 ctermfg=NONE
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    \,sm:block-blinkwait175-blinkoff150-blinkon175
highlight Cursor guifg=#000001 guibg=#cccccc
highlight Cursor2 guifg=#000000 guibg=#cccccc
highlight lCursor guifg=NONE guibg=#603020

" set cursorline

" imap jj <Esc>

"set clipboard=unnamed
set clipboard=

function ClearRegs() abort
  let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in regs
    call setreg(r, @_)
  endfor
endfunction

function! LightlineCurrentDirectory(n) abort
  " return fnamemodify(getcwd(tabpagewinnr(a:n), a:n), ':h:t') . '/' . @%
  return fnamemodify(getcwd(tabpagewinnr(a:n), a:n), ':t') . '/'
  " return fnamemodify(@%, ':h:t') . '/' . fnamemodify(@%, ':t')
endfunction
set relativenumber
set noshowmode
let g:lightline = {
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'cocstatus': 'coc#status',
      \   'CustomTabname': 'CustomTabname'
      \ },
      \ 'tab': {
      \   'active': [ 'tabnum', 'filename', 'modified' ],
      \   'inactive': ['tabnum', 'filename', 'modified' ]
      \ },
      \ 'tab_component_function': {
      \   'cwd': 'LightlineCurrentDirectory'
      \  },
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
    \               ['cocstatus', 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
      \ },
      \ }

let g:lightline.winwidth = 202


let g:lightline.enable = {
      \ 'tabline': 1
      \}

set showtabline=1
let g:lightline.tabline = {
    \ 'left': [ [ 'tabs' ] ],
    \ 'right': [ [] ] }

" let g:lightline.tab = {
"     \ 'active': [ 'tabnum', 'filename', 'modified' ],
"     \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
"     \ }
let g:lightline.tabline_separator= { 'left': "", 'right': "" }
let g:lightline.tabline_subseparator= { 'left': "", 'right': "" }

let g:lightline#bufferline#show_number  = 1
let g:lightline.colorscheme = 'onedark'
" let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed = '...'

" Enable powerline fonts

let g:javascript_plugin_jsdoc = 1

"autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
"autocmd CursorHold,CursorHoldI call lightline#update()

" https://stevelosh.com/blog/2010/09/coming-home-to-vim/
" nnoremap / /\v
" vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set vb t_vb= " No more beeps
set lazyredraw


" show hidden characters
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" set colorcolumn=100

" Jump to start and end of line using the home row keys
map H ^
map L $

set conceallevel=0
autocmd FileType json
    \ autocmd BufEnter * silent set conceallevel=0
" autocmd FileType rust
"     \ autocmd BufWritePre * silent call CocActionAsync('format')

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
" hi Cursor       guifg=black     ctermfg=0   guibg=#4e9a06   ctermbg=10


map ё `
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map Ё ~
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >

" Load local .vimrc if possible
try
  source ./.vimrc
  echo "Loaded local vimrc"
catch
  "
endtry
