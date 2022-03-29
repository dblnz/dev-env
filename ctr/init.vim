
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=0
set smarttab

set foldmethod=syntax nofoldenable
set nonumber ruler nowrap
set incsearch
set cursorline
set hidden
set textwidth=95
set scrolloff=3


set autoread
au FocusGained, BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

syntax on
filetype plugin indent on
set updatetime=100
set foldmethod=indent
set signcolumn=yes:1

" Plugins
call plug#begin('~/.config/nvim/plugins')
Plug 'lifepillar/vim-solarized8'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh'}
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'arakashic/chromatica.nvim'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
call plug#end()

" Enable LanguageClient
let g:LanguageClient_serverCommands = {
	\ 'rust': ['rustup', 'run', 'stable', 'rls'],
	\ 'python': ['/usr/local/bin/pyls'],
	\ 'c': ['/usr/bin/ccls'],
	\ 'cpp': ['/usr/bin/ccls'],
	\}

" C devel
let g:chromatica#libclang_path='/usr/lib64/libclang.so'
let g:chromatica#enable_at_startup=1
let g:chromatica#responsive_mode=1

" Set autocomplete
set completeopt=menuone,noinsert
autocmd BufEnter * call ncm2#enable_for_buffer()

" fzf
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

" nerdtree
let g:NERDSpaceDelim=1

" Colors
set termguicolors
set background=dark
let g:airline_theme='minimalist'
silent! colorscheme solarized8_flat
hi Normal ctermbg=NONE guibg=NONE
hi CursorLine guibg=#0f3e4a
hi CursorLineNr guibg=#0f3e4a guifg=#a3b4b6

" Git UI
hi GitGutterChangeLine guibg=#073c40
hi link GitGutterAddLine GitGutterChangeLine
hi link GitGutterDeleteLine GitGutterChangeLine
hi GitGutterAdd guifg=#88bb44
hi GitGutterChange guifg=#eebb44
hi GitGutterDelete guifg=#ff4444
hi DiffChange guifg=NONE guibg=#073642
hi! link DiffAdd DiffChange
hi! link DiffDelete DiffChange
hi DiffText guifg=NONE guibg=#0f4840
set diffopt+=vertical

" Mappings
" Find
nnoremap <C-p>f :Files<CR>
nnoremap <C-p>b :Buffers<CR>
nnoremap <C-p>g :Rg<CR>
nnoremap <C-p>f :Files<CR>
nnoremap <C-p>w wbvey:Rg <C-r>"<CR>
nnoremap <C-p>t :NERDTreeToggle<cr>

"Git
nnoremap <C-g><C-g> :GitGutterToggle<cr>
nnoremap <C-g>l :GitGutterLineHighlightsToggle<cr>
nnoremap <C-g>v :GitGutterPreviewHunk<cr>

"Navigation
nnoremap gc :call LanguageClient_contextMenu()<CR>
nnoremap gd :call LanguageClient#textDocument_definition()<CR>
nnoremap gr :call LanguageClient#textDocument_references()<CR>
nnoremap gh :call LanguageClient#textDocument_hover()<CR>

"Tabs
nnoremap tt :tab split<cr>
nnoremap tc :tabnew<cr>
nnoremap <leader><leader>1 1gt
nnoremap <leader><leader>2 2gt
nnoremap <leader><leader>3 3gt
nnoremap <leader><leader>4 4gt
nnoremap <leader><leader>5 5gt
nnoremap <leader><leader>6 6gt
nnoremap <leader><leader>7 7gt

