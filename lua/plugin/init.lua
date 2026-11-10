return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme gruvbox]])
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"python",
				"javascript",
				"typescript",
				"tsx",
				"htmldjango",
				"yaml",
				"markdown",
				"markdown_inline",
				"go",
				"rust",
				"toml",
				"c",
				"cpp",
				"cmake",
				"make",
				"bash",
				"zsh",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("config.lspconfig")
		end,
	},

	{
		"mason-org/mason.nvim",
		lazy = false,
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		lazy = false,
		opts = {
			ensure_installed = {
				"vtsls",
				"eslint-lsp",
				"clangd",
				"gopls",
				"intelephense",
				"html-lsp",
				"css-lsp",
				"json-lsp",
				"yaml-language-server",
				"taplo",
				"vim-language-server",
				"basedpyright",
				"ruff",
				"djlint",
				"prettierd",
				"blade-formatter",
			},
		},
	},

	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = require("config.conform"),
	},

	{
		"b0o/SchemaStore.nvim",
		lazy = true,
	},

	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = require("config.blink"),
		opts_extend = { "sources.default" },
	},

	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			require("config.telescope")
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},

	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPre", "BufNewFile" },
		opts = { render = "background", enable_named_colors = true },
	},

	{
		"gbprod/yanky.nvim",
		opts = { highlight = { on_yank = true, on_put = true, timer = 300 } },
	},

	{
		"SmiteshP/nvim-navic",
		opts = { lsp = { auto_attach = true }, highlight = true },
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("bufferline").setup({
				options = {
					separator_style = "slant",
				},
			})
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "󰙅 Open/Close Neotree" },
		},
		opts = {
			source_selector = {
				winbar = true,
				statusline = false,
			},
		},
	},

	{
		"Crysthamus/nvim-file-operations",
		dependencies = {
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			require("nvim-file-operations").setup()
		end,
	},

	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependecies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.evil_lualine")
		end,
	},
}
