-- Doesn't work with nvimtree
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Allows moving selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
-- append line below remove CR LF
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy/paste from registers
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>P", "\"+P")
-- vim.keymap.set("x", "<leader>p", "\"_dP")

-- Store to unused buffer so that the default buffer
-- does not get modified
vim.keymap.set("n", "<leader>c", "\"_c")
vim.keymap.set("v", "<leader>c", "\"_c")
vim.keymap.set("n", "<leader>C", "\"_C")
vim.keymap.set("v", "<leader>C", "\"_C")
vim.keymap.set("n", "<leader>x", "\"_x")
vim.keymap.set("v", "<leader>x", "\"_x")
vim.keymap.set("n", "<leader>X", "\"_X")
vim.keymap.set("v", "<leader>X", "\"_X")
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>D", "\"_D")
vim.keymap.set("v", "<leader>D", "\"_D")

-- Replace name
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Unmap Q to not quit unexpectedly
vim.keymap.set("n", "Q", "<nop>")
-- Remap quit and write
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("v", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("v", "<leader>w", ":w<CR>")
