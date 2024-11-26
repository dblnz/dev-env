-- Git Diffview keymaps
vim.keymap.set("n", "<C-g>o", vim.cmd.DiffviewOpen)
vim.keymap.set("n", "<C-g>c", vim.cmd.DiffviewClose)
vim.keymap.set("n", "<C-g>l", ":DiffviewOpen HEAD~1")

