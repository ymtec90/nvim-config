local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		vue = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },
		less = { "prettierd" },
		html = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
		graphql = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		python = { "ruff" },
		htmldjango = { "djlint" },
		blade = { "blade-formatter" },
	},

	format_on_save = function(bufnr)
		if vim.bo[bufnr].filetype == "php" then
			return
		end
		require("config.lspconfig").code_actions_on_save(bufnr)
		return { timeout_ms = 2000, lsp_format = "fallback" }
	end,
}

return options
