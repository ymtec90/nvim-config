local M = {}

M.opts = {
	-- Desliga LSP/treesitter/etc. em arquivos grandes
	bigfile = { enabled = true, size = 1.5 * 1024 * 1024 },
	-- Renderiza o arquivo antes de carregar plugins
	quickfile = { enabled = true },

	-- Substitui o vim.notify
	notifier = { enabled = true, timeout = 3000, style = "compact" },
	-- vim.ui.input bonito: renomear no LSP e no Neo-tree
	input = { enabled = true },

	-- Guias de identação e destaque do escopo atual
	indent = {
		enabled = true,
		animate = { enabled = true },
		scope = { enabled = true },
	},
	scope = { enabled = true },

	-- Destaca referências do símbolo sob o cursor (LSP)
	words = { enabled = true, debounce = 200 },

	-- Sinais do gitsigns + diagnósticos + folds em uma coluna só
	statuscolumn = { enabled = true },

	-- Terminal flutuante/split
	terminal = { enabled = true },

	-- Tela inicial com atalhos de busca usando o Telescope
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{ icon = " ", title = "Arquivos recentes", section = "recent_files", cwd = true, indent = 2, padding = 1 },
			{ icon = " ", title = "Projetos", section = "projects", indent = 2, padding = 1 },
			{ section = "startup" },
		},
	},

	-- Como eu utilizo WezTerm, mantenho essa funcionalidade ligada
	-- Desativar caso esteja usando outro terminal sem suporte ao
	-- Kitty Graphics Protocol
	image = { enabled = true },

	-- LazyGit para gerenciar repositórios no Neovim
	lazygit = { enabled = true },

	-- Módulos com funcionalidades descobertas são desativados
	picker = { enabled = false }, -- Já uso Telescope
	explorer = { enabled = false }, -- Já uso Neo-tree
	scroll = { enabled = false }, -- Centralizo a busca com o mapping nzz
}

M.keys = {
	-- Notificações
	{
		"<leader>n",
		function()
			Snacks.notifier.show_history()
		end,
		desc = "Histórico de notificações",
	},
	{
		"<leader>un",
		function()
			Snacks.notifier.hide()
		end,
		desc = "Fechar notificações",
	},

	-- Buffers
	{
		"<leader>bd",
		function()
			Snacks.bufdelete()
		end,
		desc = "Fechar buffer",
	},
	{
		"<leader>bo",
		function()
			Snacks.bufdelete.other()
		end,
		desc = "Fechar outros buffers",
	},

	-- Terminal
	{
		"<leader>t",
		function()
			Snacks.terminal()
		end,
		mode = { "n", "t" },
		desc = "Terminal",
	},

	-- LazyGit
	{
		"<leader>Gl",
		function()
			Snacks.lazygit()
		end,
		desc = "Abrir o lazygit",
	},

	-- Referências do LSP (snacks.words)
	{
		"]]",
		function()
			Snacks.words.jump(vim.v.count1)
		end,
		mode = { "n", "t" },
		desc = "Próxima referência",
	},
	{
		"[[",
		function()
			Snacks.words.jump(-vim.v.count1)
		end,
		mode = { "n", "t" },
		desc = "Referência anterior",
	},

	-- Git
	{
		"<leader>Gb",
		function()
			Snacks.gitbrowse()
		end,
		mode = { "n", "v" },
		desc = "Abrir no GitHub",
	},

	-- Foco
	{
		"<leader>z",
		function()
			Snacks.zen()
		end,
		desc = "Modo Zen",
	},
	{
		"<leader>.",
		function()
			Snacks.scratch()
		end,
		desc = "Scratch buffer",
	},
}

M.init = function()
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			Snacks.toggle.option("wrap", { name = "Quebra de linha" }):map("<leader>uw")
			Snacks.toggle.option("relativenumber", { name = "Número relativo" }):map("<leader>uL")
			Snacks.toggle.diagnostics():map("<leader>ud")
			Snacks.toggle.inlay_hints():map("<leader>uh")
			Snacks.toggle.indent():map("<leader>ug")
			Snacks.toggle.treesitter():map("<leader>uT")
			Snacks.toggle.dim():map("<leader>uD")
		end,
	})
end

return M
