return {
    -- LazyVim Config
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin",
        },
    },

    -- Plugins
    { import = "lazyvim.plugins.extras.lang.typescript" },
    {
        -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
        import = "lazyvim.plugins.extras.lang.json"
    },
    { "sindrets/diffview.nvim" },
    {
        "github/copilot.vim",
        lazy = true,
    },
}
