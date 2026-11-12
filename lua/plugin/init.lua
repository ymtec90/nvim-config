return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme gruvbox]])
			require("config.navic")
			require("config.neotree")
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("config.which-key")
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@module "snacks"
		---@type snacks.Config
		opts = require("config.snacks").opts,
		keys = require("config.snacks").keys,
		init = require("config.snacks").init,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"scss",
				"python",
				"javascript",
				"typescript",
				"tsx",
				"vue",
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
				"regex",
			})
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(a)
					if pcall(vim.treesitter.start, a.buf) then
						vim.bo[a.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
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
				"codelldb",
				"delve",
				"debugpy",
				"js-debug-adapter",
				"php-debug-adapter",
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
		"LunarVim/breadcrumbs.nvim",
		dependencies = {
			{
				"SmiteshP/nvim-navic",
				opts = {
					lsp = {
						auto_attach = true,
					},
					highlight = true,
					separator = "  ",
					depth_limit = 0,
					icons = {
						File = "󰈙 ",
						Module = " ",
						Namespace = "󰌗 ",
						Package = " ",
						Class = "󰌗 ",
						Method = "󰆧 ",
						Property = " ",
						Field = " ",
						Constructor = " ",
						Enum = "󰕘 ",
						Interface = "󰕘 ",
						Function = "󰊕 ",
						Variable = "󰆧 ",
						Constant = "󰏿 ",
						String = "󰀬 ",
						Number = "󰎠 ",
						Boolean = "◩ ",
						Array = "󰅪 ",
						Object = "󰅩 ",
						Key = "󰌋 ",
						Null = "󰟢 ",
						EnumMember = " ",
						Struct = "󰌗 ",
						Event = " ",
						Operator = "󰆕 ",
						TypeParameter = "󰊄 ",
					},
				},
			},
		},
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			separator = "  ",
			icons = {
				Folder = "󰉋 ",
			},
		},
		config = function(_, opts)
			require("breadcrumbs").setup(opts)
		end,
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
		cmd = "Neotree",
		opts = require("config.neotree").options,
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

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
			"leoluz/nvim-dap-go",
		},
		config = function()
			require("config.dap")
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"brianhuster/live-preview.nvim",
		cmd = "LivePreview",
		opts = {
			port = 8081,
			browser = "default",
		},
		keys = {
			{ "<leader>lp", ":LivePreview<CR>", desc = "Iniciar Live Preview" },
		},
	},

	{
		"windwp/nvim-ts-autotag",
		ft = {
			"html",
			"javascriptreact",
			"typescriptreact",
			"htmldjango",
			"php",
			"blade",
		},
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},

	{
		"hiphish/rainbow-delimiters.nvim",
		event = "User FilePost",
		config = function()
			require("config.rb-delimiters")
		end,
	},

	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewFileHistory",
		},
		config = function()
			require("diffview").setup({
				view = {
					merge_tool = {
						layout = "diff3_mixed",
					},
				},
			})
		end,
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = "Neogit",
		config = function()
			require("neogit").setup({
				integrations = {
					diffview = true,
					telescope = true,
				},
				kind = "tab",
				commit_editor = {
					kind = "split",
				},
			})
		end,
	},

	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		cmd = { "Octo" },
		config = function()
			require("octo").setup({
				enable_builtin = true,
				default_remote = { "upstream", "origin" },
				suppress_missing_scope = {
					projects_v2 = true,
				},
			})
		end,
	},

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
		keys = {
			{ "<leader>Ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "IA Ações" },
			{ "<leader>Cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "IA Chat" },
			{ "<leader>GA", "<cmd>CodeCompanion /commit_padrao<cr>", mode = "n", desc = "IA Gerar Commit" },
		},
		config = function()
			require("config.codecompanion")
		end,
	},
}
