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
		import = "lazyvim.plugins.extras.lang.json",
	},
	{ "sindrets/diffview.nvim" },
	{
		"github/copilot.vim",
		lazy = true,
		enable = false,
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			-- Default mapping is <M-]>
			vim.g.copilot_no_tab_map = true
			vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
		end,
	},
}
