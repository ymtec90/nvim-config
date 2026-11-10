local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },

		mappings = {
			i = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-c>"] = actions.close,
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,
			},
			n = {
				["q"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true, -- Mostrar arquivos ocultos (ex: .gitignore ignorados ou dotfiles)
			file_ignore_patterns = { "node_modules", ".git/" },
		},
	},
	extensions = {
		-- Configurações de extensões (ex: fzf, live_grep_args, etc) vão aqui
	},
})
