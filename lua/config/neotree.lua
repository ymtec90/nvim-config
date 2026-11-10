local M = {}

local function setup_neotree_gruvbox_highlights()
	local colors = {
		bg0 = "#282828", -- Fundo escuro padrão
		bg1 = "#3c3836", -- Fundo elevado / CursorLine
		bg2 = "#504945", -- Guias de indentação
		fg = "#ebdbb2", -- Texto principal
		gray = "#928374", -- Comentários e itens ignorados
		red = "#fb4934",
		green = "#b8bb26",
		yellow = "#fabd2f",
		blue = "#83a598",
		purple = "#d3869b",
		aqua = "#8ec07c",
		orange = "#fe8019",
	}

	local hl_map = {
		-- Estrutura da janela e fundo
		NeoTreeNormal = { fg = colors.fg, bg = colors.bg0 },
		NeoTreeNormalNC = { fg = colors.fg, bg = colors.bg0 },
		NeoTreeSignColumn = { bg = colors.bg0 },
		NeoTreeEndOfBuffer = { fg = colors.bg0, bg = colors.bg0 },
		NeoTreeCursorLine = { bg = colors.bg1, bold = true },
		NeoTreeWinSeparator = { fg = colors.bg1, bg = colors.bg0 },
		NeoTreeVertSplit = { fg = colors.bg1, bg = colors.bg0 },

		-- Diretórios, arquivos e navegação
		NeoTreeDirectoryIcon = { fg = colors.yellow },
		NeoTreeDirectoryName = { fg = colors.fg, bold = true },
		NeoTreeRootName = { fg = colors.orange, bold = true },
		NeoTreeFileName = { fg = colors.fg },
		NeoTreeFileNameOpened = { fg = colors.aqua, bold = true },
		NeoTreeSymbolicLinkTarget = { fg = colors.purple },
		NeoTreeExpander = { fg = colors.gray },
		NeoTreeIndentMarker = { fg = colors.bg2 },
		NeoTreeDimText = { fg = colors.gray },
		NeoTreeDotfile = { fg = colors.gray },
		NeoTreeHiddenByName = { fg = colors.gray },

		-- Status do Git
		NeoTreeGitAdded = { fg = colors.green },
		NeoTreeGitModified = { fg = colors.yellow },
		NeoTreeGitDeleted = { fg = colors.red },
		NeoTreeGitConflict = { fg = colors.orange, bold = true },
		NeoTreeGitIgnored = { fg = colors.gray },
		NeoTreeGitUntracked = { fg = colors.purple },
		NeoTreeGitStaged = { fg = colors.green },
		NeoTreeGitUnstaged = { fg = colors.red },

		-- Abas superiores (Source Selector / Winbar)
		NeoTreeTabActive = { fg = colors.yellow, bg = colors.bg1, bold = true },
		NeoTreeTabInactive = { fg = colors.gray, bg = colors.bg0 },
		NeoTreeTabSeparatorActive = { fg = colors.bg0, bg = colors.bg1 },
		NeoTreeTabSeparatorInactive = { fg = colors.bg0, bg = colors.bg0 },

		-- Janela flutuante (Float)
		NeoTreeFloatNormal = { fg = colors.fg, bg = colors.bg0 },
		NeoTreeFloatBorder = { fg = colors.yellow, bg = colors.bg0 },
		NeoTreeFloatTitle = { fg = colors.yellow, bg = colors.bg0, bold = true },
		NeoTreeTitleBar = { fg = colors.bg0, bg = colors.yellow, bold = true },
	}

	for group, opts in pairs(hl_map) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

-- Reatribui as cores se o colorscheme for recarregado
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*gruvbox*",
	callback = setup_neotree_gruvbox_highlights,
})

setup_neotree_gruvbox_highlights()

M.options = {
	sources = {
		"filesystem",
		"buffers",
		"git_status",
		"document_symbols",
	},
	source_selector = {
		winbar = true,
		statusline = false,
		sources = {
			{ source = "filesystem", display_name = " 󰉋 Files " },
			{ source = "buffers", display_name = " 󰕒 Buffers " },
			{ source = "git_status", display_name = " 󰊢 Git " },
			{ source = "document_symbols", display_name = " 󰌗 Symbols " },
		},
	},
	close_if_last_window = true,
	default_component_configs = {
		indent = {
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		icon = {
			folder_closed = "󰉋",
			folder_open = "󰉋",
			folder_empty = "󰷏",
			default = "󰈙",
			highlight = "NeoTreeFileIcon",
		},
		git_status = {
			symbols = {
				added = " ",
				modified = "󰝤 ",
				deleted = " ",
				renamed = "󰑕 ",
				untracked = "󰄱 ",
				ignored = "󰈉 ",
				unstaged = "󰄱 ",
				staged = " ",
				conflict = " ",
			},
		},
	},
	filesystem = {
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
		use_libuv_file_watcher = true,
		filtered_items = {
			visible = false,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
	window = {
		width = 35,
		mappings = {
			["<space>"] = "none",
			["l"] = "open",
			["h"] = "close_node",
			["s"] = "open_vsplit",
			["S"] = "open_split",
			["t"] = "open_tabnew",
			["P"] = { "toggle_preview", config = { use_float = true } },
			["H"] = "toggle_hidden",
		},
	},
}

return M
