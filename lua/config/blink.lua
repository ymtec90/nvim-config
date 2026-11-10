local options = {

	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
		kind_icons = {
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "󰑭",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "󰩫",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "󰙅",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰊄",
		},
	},
	completion = {
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
		},
		list = {
			max_items = 30,
			selection = { preselect = true, auto_insert = false },
		},
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		menu = {
			draw = {
				columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
	},
	snippets = { preset = "default" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	signature = { enabled = true },
	fuzzy = { implementation = "prefer_rust_with_warning" },
	cmdline = {
		enabled = true,
		keymap = {
			preset = "cmdline",
			["<Tab>"] = { "show_and_insert", "select_next" },
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
		completion = {
			menu = {
				auto_show = function(ctx)
					return vim.fn.getcmdtype() == ":"
				end,
			},
			ghost_text = { enabled = true },
			list = { selection = { preselect = false, auto_insert = true } },
		},
	},
}

return options
