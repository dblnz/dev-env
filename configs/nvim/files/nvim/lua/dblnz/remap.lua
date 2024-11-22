-- Doesn't work with nvimtree
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Allows moving selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-j>", "<C-j>zz")
vim.keymap.set("n", "<C-k>", "<C-k>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy/paste from registers
-- vim.keymap.set("x", "<leader>p", "\"_dP")
-- vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("v", "<leader>y", "\"+y")
-- vim.keymap.set("n", "<leader>Y", "\"+Y")
-- vim.keymap.set("n", "<leader>d", "\"_d")
-- vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-g>f", function()
--     vim.lsp.buf.format()
-- end)

-- Replace name
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Remap quit and write
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("v", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("v", "<leader>w", ":w<CR>")
