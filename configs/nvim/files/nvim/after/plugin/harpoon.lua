
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<C-h>a", mark.add_file)
vim.keymap.set("n", "<C-t>h", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-h>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-h>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-h>4", function() ui.nav_file(4) end)
