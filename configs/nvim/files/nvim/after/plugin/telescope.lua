local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

local theme_opts = require("telescope.themes").get_ivy()

-- Sort descending otherwise the results are not shown correctly
theme_opts["sorting_strategy"] = "descending"

telescope.setup({
	defaults = {
	},
	pickers = {
		find_files = {
            theme = "ivy",
		},
        git_files = {
            theme = "ivy",
        }
	},

    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        },
        ["ui-select"] = {
            require("telescope.themes").get_cursor {
              -- even more opts
            }
        }
    }
})

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
require("telescope").load_extension("fzf")

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-f>f', function() builtin.find_files(theme_opts) end, {})
vim.keymap.set('n', '<C-f>g', builtin.git_files, {})
-- Ask for input and sarch
vim.keymap.set('n', '<C-f>s', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
-- Search for word under cursor
vim.keymap.set('n', '<C-f>w', function()
    builtin.grep_string({ search = vim.fn.expand('<cword>') });
end)
-- Search for word including special chars under cursor
vim.keymap.set('n', '<C-f>W', function()
    builtin.grep_string({ search = vim.fn.expand('<cWORD>') });
end)
