-- Cria o tipo de arquivo Blade
vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })

-- augroup filetype_opts
local filetype_opts = vim.api.nvim_create_augroup("filetype_opts", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = filetype_opts,
	pattern = {
		"html",
		"htmldjango",
		"blade",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"json",
		"jsonc",
		"yaml",
	},
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = filetype_opts,
	pattern = "go",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 0
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = filetype_opts,
	pattern = "python",
	callback = function()
		vim.opt_local.colorcolumn = "89"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = filetype_opts,
	pattern = "php",
	callback = function()
		vim.opt_local.colorcolumn = "121"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = filetype_opts,
	pattern = "rust",
	callback = function()
		vim.opt_local.colorcolumn = "101"
	end,
})

-- augroup cursor_off
local cursor_off = vim.api.nvim_create_augroup("cursor_off", { clear = true })

vim.api.nvim_create_autocmd("WinLeave", {
	group = cursor_off,
	pattern = "*",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

vim.api.nvim_create_autocmd("WinEnter", {
	group = cursor_off,
	pattern = "*",
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- augroup htmldjango
local htmldjango = vim.api.nvim_create_augroup("htmldjango", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = htmldjango,
	pattern = "*.html",
	callback = function()
		local dir = vim.fn.expand("%:p:h") .. ";"
		if vim.fn.findfile("manage.py", dir) ~= "" then
			vim.opt_local.filetype = "htmldjango"
		end
	end,
})

-- augroup ConfigsMarkdown
local configs_markdown = vim.api.nvim_create_augroup("ConfigsMarkdown", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = configs_markdown,
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.conceallevel = 2
	end,
})

-- augroup numbertoggle
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

-- Ativa números relativos ao entrar no buffer, ganhar foco ou sair do modo insert
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	group = numbertoggle,
	pattern = "*",
	callback = function()
		if vim.o.number and vim.api.nvim_get_mode().mode ~= "i" then
			vim.o.relativenumber = true
		end
	end,
})

-- Desativa números relativos ao sair do buffer, perder foco ou entrar no modo insert
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = numbertoggle,
	pattern = "*",
	callback = function()
		if vim.o.number then
			vim.o.relativenumber = false
		end
	end,
})

-- PHP: Pint / PHP-CS-Fixer depois de salvar; LSP (Intelephense) se não houver
local function php_fixer(bufnr)
	local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
	for _, bin in ipairs({ "vendor/bin/pint", "vendor/bin/php-cs-fixer" }) do
		local found = vim.fn.findfile(bin, dir .. ";")
		if found ~= "" then
			return vim.fn.fnamemodify(found, ":p")
		end
	end
	return vim.fn.exepath("php-cs-fixer")
end

local php_group = vim.api.nvim_create_augroup("php_autofix", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = php_group,
	pattern = "*.php",
	callback = function(args)
		-- Fora o blade: *.php também casa com *.blade.php
		if vim.bo[args.buf].filetype ~= "php" then
			return
		end
		local fixer = php_fixer(args.buf)
		vim.b[args.buf].php_fixer = fixer
		if fixer == "" and #vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/formatting" }) > 0 then
			vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 2000 })
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = php_group,
	pattern = "*.php",
	callback = function(args)
		local fixer = vim.b[args.buf].php_fixer or ""
		if fixer == "" then
			return
		end
		local buf = args.buf
		local file = vim.api.nvim_buf_get_name(buf)
		local cmd = fixer:match("pint$") and { fixer, "--quiet", file } or { fixer, "fix", "--quiet", file }
		vim.system(cmd, {}, function()
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					vim.cmd("checktime " .. buf)
				end
			end)
		end)
	end,
})

vim.api.nvim_create_user_command("PHPFix", "write", {})

-- Equivalente ao 'trim_whitespace' + 'remove_trailing_lines' do ALE
-- Markdown fica de fora: dois espaços no fim da linha são quebra de linha.
-- Diff/patch também, para não corromper patches.
vim.g.clean_ws_exclude = { "markdown", "diff", "patch" }

local function clean_whitespace(bufnr)
	local bo = vim.bo[bufnr]
	if
		bo.binary
		or not bo.modifiable
		or vim.b[bufnr].no_clean_ws
		or vim.tbl_contains(vim.g.clean_ws_exclude, bo.filetype)
	then
		return
	end
	local view = vim.fn.winsaveview()
	-- trim_whitespace: espaços e tabs no fim das linhas
	vim.cmd([[keeppatterns silent! %s/\s\+$//e]])
	-- remove_trailing_lines: linhas vazias no fim do arquivo
	vim.cmd([[keeppatterns silent! %s/\n\+\%$//e]])
	vim.fn.winrestview(view)
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("clean_whitespace", { clear = true }),
	callback = function(args)
		clean_whitespace(args.buf)
	end,
})

-- Liga/desliga no buffer atual (útil para arquivos de terceiros e diffs pequenos em PR)
vim.api.nvim_create_user_command("CleanWSToggle", function()
	vim.b.no_clean_ws = not vim.b.no_clean_ws
	print("Limpeza de espaços: " .. (vim.b.no_clean_ws and "OFF" or "ON"))
end, {})
