return {
    -- add any tools you want to have installed below
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup()

        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                "cssls",
                "eslint",
                "flake8",
                "gopls",
                "html",
                "jsonls",
                "lua_ls",
                "rust_analyzer",
                "stylua",
                "shellcheck",
                "shfmt",
                "pyright",
                "tailwindcss",
                "ts_ls",
            },
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettier",
                "stylua", -- lua formatter
                "isort", -- python formatter
                "black", -- python formatter
                "pylint",
                "eslint_d",
            },
        })
    end,
}
