return {
    -- change some telescope options and a keymap to browse plugin files
    "nvim-telescope/telescope.nvim",
    keys = {
        -- add a keymap to browse plugin files
        -- stylua: ignore
        {
            "<C-f>f",
            function() require("telescope.builtin").find_files() end,
            desc = "Find Plugin File",
            mode = { "n" },
        },
        {
            "<C-f>g",
            function() require("telescope.builtin").git_files() end,
            desc = "Find Git Files",
            mode = { "n" },
        },
        {
            "<C-f>s",
            function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end,
            desc = "Search for String",
            mode = { "n" },
        },
        {
            "<C-f>w",
            function() require("telescope.builtin").grep_string({ search = vim.fn.expand('<cword>') }) end,
            desc = "Search for word under cursor",
            mode = { "n" },
        },
        {
            "<C-f>W",
            function() require("telescope.builtin").grep_string({ search = vim.fn.expand('<cWORD>') }) end,
            desc = "Search for word under cursor including special chars",
            mode = { "n" },
        },
    },
    -- change some options
    opts = {
        defaults = {
            layout_strategy = "horizontal",
            layout_config = { prompt_position = "top" },
            sorting_strategy = "ascending",
            winblend = 0,
        },
    },
}
