-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Doesn't work with nvimtree
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
local map = LazyVim.safe_keymap_set

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Allows moving selected lines - already mapped to <A-j>
--vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
--vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- translate the below command into LazyVim one
-- vim.keymap.set("n", "Y", "yg$")
map({ "n" }, "Y", "yg$", { desc = "Yank to end of line" })
-- append line below remove CR LF
-- vim.keymap.set("n", "J", "mzJ`z")
map({ "n" }, "J", "mzJ`z", { desc = "Append line below and remove CR LF" })
--vim.keymap.set("n", "n", "nzzzv")
--vim.keymap.set("n", "N", "Nzzzv")
map({ "n" }, "n", "nzzzv", { desc = "Search next and center" })
map({ "n" }, "N", "Nzzzv", { desc = "Search previous and center" })

-- Copy/paste from registers
-- vim.keymap.set("n", "<leader>y", "\"+y")
map({ "n" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
-- vim.keymap.set("v", "<leader>y", "\"+y")
map({ "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
-- vim.keymap.set("n", "<leader>Y", "\"+Y")
map({ "n" }, "<leader>Y", '"+Y', { desc = "Yank to clipboard" })
-- vim.keymap.set("n", "<leader>p", "\"+p")
map({ "n" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
-- vim.keymap.set("v", "<leader>p", "\"+p")
map({ "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
-- vim.keymap.set("n", "<leader>P", "\"+P")
map({ "n" }, "<leader>P", '"+P', { desc = "Paste from clipboard" })

-- Store to unused buffer so that the default buffer
-- does not get modified
-- vim.keymap.set("n", "<leader>c", "\"_c")
map({ "n" }, "<leader>c", '"_c', { desc = "Change without yanking" })
-- vim.keymap.set("v", "<leader>c", "\"_c")
map({ "v" }, "<leader>c", '"_c', { desc = "Change without yanking" })
-- vim.keymap.set("n", "<leader>C", "\"_C")
map({ "n" }, "<leader>C", '"_C', { desc = "Change without yanking" })
-- vim.keymap.set("v", "<leader>C", "\"_C")
map({ "v" }, "<leader>C", '"_C', { desc = "Change without yanking" })
-- vim.keymap.set("n", "<leader>x", "\"_x")
map({ "n" }, "<leader>x", '"_x', { desc = "Delete without yanking" })
-- vim.keymap.set("v", "<leader>x", "\"_x")
map({ "v" }, "<leader>x", '"_x', { desc = "Delete without yanking" })
-- vim.keymap.set("n", "<leader>X", "\"_X")
map({ "n" }, "<leader>X", '"_X', { desc = "Delete without yanking" })
-- vim.keymap.set("v", "<leader>X", "\"_X")
map({ "v" }, "<leader>X", '"_X', { desc = "Delete without yanking" })
-- vim.keymap.set("n", "<leader>d", "\"_d")
map({ "n" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
-- vim.keymap.set("v", "<leader>d", "\"_d")
map({ "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
-- vim.keymap.set("n", "<leader>D", "\"_D")
map({ "n" }, "<leader>D", '"_D', { desc = "Delete without yanking" })
-- vim.keymap.set("v", "<leader>D", "\"_D")
map({ "v" }, "<leader>D", '"_D', { desc = "Delete without yanking" })

-- Replace name
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map({ "n" }, "<leader>s", "[[:%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left>]]", { desc = "Replace name" })

-- Unmap Q to not quit unexpectedly
-- vim.keymap.set("n", "Q", "<nop>")
map({ "n" }, "Q", "<nop>", { desc = "Unmap Q" })
-- Remap quit and write
--vim.keymap.set("n", "<leader>q", ":q<CR>")
map({ "n" }, "<leader>q", ":q<CR>", { desc = "Quit" })
-- vim.keymap.set("v", "<leader>q", ":q<CR>")
map({ "v" }, "<leader>q", ":q<CR>", { desc = "Quit" })
-- vim.keymap.set("n", "<leader>w", ":w<CR>")
map({ "n" }, "<leader>w", ":w<CR>", { desc = "Write" })
-- vim.keymap.set("v", "<leader>w", ":w<CR>")
map({ "v" }, "<leader>w", ":w<CR>", { desc = "Write" })
