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
		icon = { icon = "󰋖", color = "orange" },
	},
	{
		"<leader>fo",
		"<cmd>Telescope oldfiles<cr>",
		desc = "Arquivos Recentes",
		icon = { icon = "󰋚", color = "purple" },
	},

	-- Código / LSP & Conform
	{ "<leader>c", group = "Código & LSP", icon = { icon = "", color = "blue" } },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", icon = { icon = "󱐋", color = "yellow" } },
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
	{ "[d", vim.diagnostic.goto_prev, desc = "Diagnóstico Anterior", icon = { icon = "󰒮", color = "blue" } },
	{ "]d", vim.diagnostic.goto_next, desc = "Próximo Diagnóstico", icon = { icon = "󰒭", color = "blue" } },

	-- Navegação de Código (LSP)
	{ "g", group = "Navegação / Definições", icon = { icon = "󰒕", color = "azure" } },
	{ "gd", vim.lsp.buf.definition, desc = "Ir para Definição", icon = { icon = "󰅩", color = "blue" } },
	{ "gD", vim.lsp.buf.declaration, desc = "Ir para Declaração", icon = { icon = "󰅩", color = "cyan" } },
	{ "gi", vim.lsp.buf.implementation, desc = "Ir para Implementação", icon = { icon = "󰅩", color = "green" } },
	{ "gr", vim.lsp.buf.references, desc = "Referências", icon = { icon = "󰅩", color = "yellow" } },
	{ "K", vim.lsp.buf.hover, desc = "Hover Docs", icon = { icon = "󰋖", color = "orange" } },

	-- Explorer / Neo-tree
	{ "<leader>e", group = "Explorer (Neo-tree)", icon = { icon = "󰙅", color = "green" } },
	{
		"<leader>ee",
		"<cmd>Neotree toggle filesystem left<cr>",
		desc = "Alternar Explorer",
		icon = { icon = "󰙅", color = "green" },
	},
	{
		"<leader>ef",
		"<cmd>Neotree reveal<cr>",
		desc = "Revelar Arquivo Atual",
		icon = { icon = "󰈞", color = "blue" },
	},
	{
		"<leader>eb",
		"<cmd>Neotree toggle buffers left<cr>",
		desc = "Buffers Abertos",
		icon = { icon = "󰕒", color = "yellow" },
	},
	{
		"<leader>eg",
		"<cmd>Neotree toggle git_status left<cr>",
		desc = "Status do Git",
		icon = { icon = "󰊢", color = "orange" },
	},
	{
		"<leader>es",
		"<cmd>Neotree toggle document_symbols left<cr>",
		desc = "Símbolos LSP",
		icon = { icon = "󰌗", color = "purple" },
	},
	{
		"<leader>eF",
		"<cmd>Neotree toggle float<cr>",
		desc = "Explorer Flutuante",
		icon = { icon = "󰉋", color = "cyan" },
	},
	{ "<leader>ec", "<cmd>Neotree close<cr>", desc = "Fechar Neo-tree", icon = { icon = "󰅖", color = "red" } },
})
