-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = false,
  },
  filters = {
    dotfiles = false,
  },
})

vim.keymap.set("n", "<C-t>n", vim.cmd.NvimTreeToggle)
