
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true 
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- The below lines help with line breaking at maximum textwidth
vim.opt.formatoptions:append("t")
-- workaround for autoformatting being overwriten
vim.cmd([[autocmd BufEnter * set formatoptions+=t]])
vim.opt.textwidth = 80
vim.opt.wrapmargin = 0
vim.opt.linebreak = true

-- Folding
-- The below command starts VIM with indent folding and switches to manual
-- so one can create new folds using `zf`
vim.cmd([[
augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END]])
vim.opt.foldlevel = 3
vim.opt.foldclose = all
