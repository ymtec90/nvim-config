local wk = require("which-key")

wk.setup({
	preset = "modern",
	icons = {
		breadcrumb = "»",
		separator = "➜",
		group = "+",
		ellipsis = "…",
		mappings = true,
		colors = true,
		keys = {
			Space = "󱁐 ",
			CR = "󰌑 ",
			Esc = "󱊷 ",
			BS = "󰁮 ",
			Tab = "󰌒 ",
		},
	},
	win = {
		border = "rounded",
		padding = { 1, 2 },
	},
})

wk.add({
	-- Busca / Telescope
	{ "<leader>f", group = "Buscar (Telescope)", icon = { icon = "", color = "cyan" } },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Arquivos", icon = { icon = "󰈞", color = "blue" } },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep", icon = { icon = "󰊄", color = "green" } },
	{
		"<leader>fb",
		"<cmd>Telescope buffers<cr>",
		desc = "Buffers Abertos",
		icon = { icon = "󰕒", color = "yellow" },
	},
	{
		"<leader>fh",
		"<cmd>Telescope help_tags<cr>",
		desc = "Tags de Ajuda",
		icon = { icon = "", color = "orange" },
	},
	{
		"<leader>fo",
		"<cmd>Telescope oldfiles<cr>",
		desc = "Arquivos Recentes",
		icon = { icon = "󰋚", color = "purple" },
	},

	-- Grupo de mappings para gestão de repositório
	{ "<leader>G", group = "Git", icon = { icon = "", color = "orange" } },
	{
		"<leader>GA",
		"<cmd>CodeCompanion /commit_padrao<cr>",
		mode = "n",
		desc = "IA Gerar Commit",
		icon = { icon = "", color = "blue" },
	},

	-- Grupo de mappings para gestão de repositório
	{ "<leader>O", group = "Octo (Github)", icon = { icon = "", color = "grey" } },

	-- Grupo de mappings para IA através do codecompanion
	{ "<leader>C", group = "IA", icon = { icon = "󰫢", color = "blue" } },

	-- Código / LSP & Conform
	{ "<leader>c", group = "Código, LSP & IA", icon = { icon = "", color = "blue" } },
	{ "<leader>cA", vim.lsp.buf.code_action, desc = "Code Action", icon = { icon = "󱐋", color = "yellow" } },
	{ "<leader>cr", vim.lsp.buf.rename, desc = "Renomear Símbolo", icon = { icon = "󰑕", color = "orange" } },
	{
		"<leader>cf",
		function()
			require("conform").format({ async = true, lsp_fallback = true })
		end,
		desc = "Formatar Código",
		icon = { icon = "󰉢", color = "cyan" },
	},

	-- Debug / DAP (Mapeamentos mnemônicos sem uso de teclas de função)
	{ "<leader>d", group = "Debug (DAP)", icon = { icon = "", color = "red" } },
	{
		"<leader>db",
		function()
			require("dap").toggle_breakpoint()
		end,
		desc = "Alternar Breakpoint",
		icon = { icon = "󰃤", color = "red" },
	},
	{
		"<leader>dc",
		function()
			require("dap").continue()
		end,
		desc = "Iniciar / Continuar",
		icon = { icon = "", color = "green" },
	},
	{
		"<leader>di",
		function()
			require("dap").step_into()
		end,
		desc = "Step Into",
		icon = { icon = "󰆹", color = "blue" },
	},
	{
		"<leader>do",
		function()
			require("dap").step_over()
		end,
		desc = "Step Over",
		icon = { icon = "󰆸", color = "blue" },
	},
	{
		"<leader>dO",
		function()
			require("dap").step_out()
		end,
		desc = "Step Out",
		icon = { icon = "󰆺", color = "blue" },
	},
	{
		"<leader>dr",
		function()
			require("dap").repl.open()
		end,
		desc = "Abrir REPL",
		icon = { icon = "󰞷", color = "purple" },
	},
	{
		"<leader>du",
		function()
			require("dapui").toggle()
		end,
		desc = "Interface",
		icon = { icon = "", color = "purple" },
	},
	{
		"<leader>dC",
		function()
			require("dap").run_to_cursor()
		end,
		desc = "Rodar até o cursor",
		icon = { icon = "󰗧", color = "green" },
	},
	{
		"<leader>de",
		function()
			require("dapui").eval()
		end,
		mode = { "n", "x" },
		desc = "Avaliar expressão",
		icon = { icon = "", color = "green" },
	},
	{
		"<leader>dT",
		function()
			local ft = vim.bo.filetype
			if ft == "go" then
				require("dap-go").debug_test()
			elseif ft == "python" then
				require("dap-python").test_method()
			else
				vim.notify("Debug de teste sob cursor: só Go e Python", vim.log.levels.WARN)
			end
		end,
		desc = "Teste sob cursor",
		icon = { icon = "󰐋", color = "green" },
	},
	{
		"<leader>dt",
		function()
			require("dap").terminate()
		end,
		desc = "Encerrar Debug",
		icon = { icon = "", color = "red" },
	},

	-- Diagnósticos
	{ "<leader>x", group = "Diagnósticos", icon = { icon = "󰒡", color = "red" } },
	{
		"<leader>xd",
		vim.diagnostic.open_float,
		desc = "Diagnóstico Flutuante",
		icon = { icon = "󰅚", color = "red" },
	},
	{
		"<leader>xq",
		vim.diagnostic.setqflist,
		desc = "Enviar para Quickfix",
		icon = { icon = "󰁨", color = "yellow" },
	},
	{
		"[d",
		function()
			vim.diagnostic.jump({ count = -1, float = true })
		end,
		desc = "Diagnóstico Anterior",
		icon = { icon = "󰒮", color = "blue" },
	},
	{
		"]d",
		function()
			vim.diagnostic.jump({ count = 1, float = true })
		end,
		desc = "Próximo Diagnóstico",
		icon = { icon = "󰒭", color = "blue" },
	},

	-- Navegação de Código (LSP)
	{ "g", group = "Navegação / Definições", icon = { icon = "󰒕", color = "azure" } },
	{ "gd", vim.lsp.buf.definition, desc = "Ir para Definição", icon = { icon = "󰅩", color = "blue" } },
	{ "gD", vim.lsp.buf.declaration, desc = "Ir para Declaração", icon = { icon = "󰅩", color = "cyan" } },
	{ "gI", vim.lsp.buf.implementation, desc = "Ir para Implementação", icon = { icon = "󰅩", color = "green" } },
	{ "gR", vim.lsp.buf.references, desc = "Referências", icon = { icon = "󰅩", color = "yellow" } },
	{ "K", vim.lsp.buf.hover, desc = "Hover Docs", icon = { icon = "󰋖", color = "orange" } },

	-- Explorer / Neo-tree
	{
		"<leader>e",
		"<cmd>Neotree toggle filesystem left<cr>",
		desc = "Abrir/Fechar Explorer",
		icon = { icon = "󰙅", color = "green" },
	},
	{

		"<leader>o",
		"<cmd>Neotree reveal<cr>",
		desc = "Visualizar Arquivo no Explorer",
		icon = { icon = "󰈞", color = "blue" },
	},
	{
		"<leader>F",
		"<cmd>Neotree toggle float<cr>",
		desc = "Explorer Flutuante",
		icon = { icon = "󰉋", color = "cyan" },
	},
})
