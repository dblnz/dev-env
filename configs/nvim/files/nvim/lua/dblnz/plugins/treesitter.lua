return {
    -- add more treesitter parsers
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {
            "bash",
            "git_config",
            "gitcommit",
            "git_rebase",
            "gitignore",
            "gitattributes",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "org",
            "python",
            "query",
            "regex",
            "rust",
            "tsx",
            "typescript",
            "vim",
            "yaml",
        },
    },
}
