local M = {}

-- Altera os símbolos para diagnóstico
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	virtual_text = { prefix = "󱓻", spacing = 2, current_line = false },
	severity_sort = true,
	update_in_insert = false,
	float = { border = "rounded", source = "if_many" },
})

-- diagnostic.checkCurrentLine: ao parar o cursor, mostra os diagnósticos da
-- linha inteira (não só os da coluna do cursor), em janela flutuante.
vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("user_diag_float", { clear = true }),
	callback = function()
		vim.diagnostic.open_float({ scope = "line", focus = false })
	end,
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		local buf = args.buf

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = buf })
		end

		if client:supports_method("textDocument/documentHighlight") then
			local group = vim.api.nvim_create_augroup("user_lsp_highlight_" .. buf, { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = group,
				buffer = buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = group,
				buffer = buf,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end

		-- O Neovim já mapeia K, grn, gra, grr, gri, gO, [d, ]d; falta o gd.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "LSP: definição" })
	end,
})

-- Code actions para Python e Javascript/Typescript
M.on_save_kinds = {
	"source.fixAll.eslint",
	"source.fixAll.ruff",
	"source.organizeImports.ruff",
}

local function apply_kind(bufnr, kind)
	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
	for _, client in ipairs(clients) do
		local params = {
			textDocument = vim.lsp.util.make_text_document_params(bufnr),
			range = {
				start = { line = 0, character = 0 },
				["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
			},
			context = { only = { kind }, diagnostics = {}, triggerKind = 1 },
		}
		local resp = client:request_sync("textDocument/codeAction", params, 2000, bufnr)
		for _, action in ipairs(resp and resp.result or {}) do
			if action.kind and vim.startswith(action.kind, kind) then
				-- O Ruff devolve a edição só no codeAction/resolve.
				if not action.edit and client:supports_method("codeAction/resolve") then
					local resolved = client:request_sync("codeAction/resolve", action, 2000, bufnr)
					if resolved and resolved.result then
						action = resolved.result
					end
				end
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
				end
				if type(action.command) == "table" then
					client:exec_cmd(action.command, { bufnr = bufnr })
				end
			end
		end
	end
end

function M.code_actions_on_save(bufnr)
	for _, kind in ipairs(M.on_save_kinds) do
		apply_kind(bufnr, kind)
	end
end

-- Define as configurações específicas para alguns servidores antes
-- de habilitar o LSP
vim.lsp.config.lua_ls = {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

vim.lsp.config.basedpyright = {
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "recommended",
				autoImportCompletions = true,
				diagnosticSeverityOverrides = {
					reportUnusedImport = "none",
					reportUnusedVariable = "none",
					reportDuplicatedImport = "none",
					reportWildcardImportFromLibrary = "none",
				},
				inlayHints = {
					variableTypes = true,
					callArgumentNames = true,
					functionReturnTypes = true,
					genericTypes = false,
				},
			},
		},
	},
}

vim.lsp.config.ruff = {
	cmd = { "ruff", "server" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}

vim.lsp.config.djls = {
	cmd = { "djls", "serve" },
	filetypes = { "htmldjango" },
	root_markers = { "manage.py", "pyproject.toml", ".git" },
}

vim.lsp.config.vtsls = {
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "literals" },
				functionLikeReturnTypes = { enabled = true },
			},
		},
	},
}

vim.lsp.config.rust_analyzer = {
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
			inlayHints = { chainingHints = { enable = true } },
		},
	},
}

vim.lsp.config.gopls = {
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			usePlaceholders = true,
			completeUnimported = true,
		},
	},
}

vim.lsp.config.clangd = {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=never",
		"--completion-style=detailed",
	},
}

vim.lsp.config.html = {
	filetypes = { "html", "templ", "blade" },
}

vim.lsp.config.jsonls = {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}

vim.lsp.config.yamlls = {
	settings = {
		yaml = {
			schemaStore = { enable = false, url = "" }, -- usa o do plugin
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}

-- Lista de servidores a serem ativados
local servers = {
	"lua_ls",
	"html",
	"cssls",
	"emmet_ls",
	"jsonls",
	"yamlls",
	"vtsls",
	"eslint",
	"basedpyright",
	"ruff",
	"djls",
	"taplo",
	"rust_analyzer",
	"clangd",
	"gopls",
	"intelephense",
	"vimls",
}

-- Injeta os mapeamentos e recursos (capabilities) nativamente aqui
vim.lsp.enable(servers)

return M
