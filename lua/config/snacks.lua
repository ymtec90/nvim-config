local M = {}

-- Funções para auxiliar a coleta dos arquivos dos projetos
-- recentes que possuam algum dos elementos destacados pelo plugin
-- todo-comments.nvim para serem mostrados no Dashboard
local todo_state = { status = "idle", items = {} } -- idle | loading | done

local function todo_project_dirs(limit)
	local dirs = {}
	-- Mesma lógica da seção "projects" do Snacks (raiz git dos arquivos recentes)
	for file in Snacks.dashboard.oldfiles() do
		local dir = Snacks.git.get_root(file)
		if dir and not vim.tbl_contains(dirs, dir) then
			dirs[#dirs + 1] = dir
			if #dirs >= limit then
				break
			end
		end
	end
	return dirs
end

local function todo_load(opts, attempt)
	attempt = attempt or 1
	local ok, Search = pcall(require, "todo-comments.search") -- carrega o plugin via lazy.nvim
	local Config = package.loaded["todo-comments.config"]
	if not ok or not (Config and Config.loaded) then
		if attempt <= 20 then -- o setup do todo-comments pode estar adiado alguns ms
			return vim.defer_fn(function()
				todo_load(opts, attempt + 1)
			end, 50)
		end
		todo_state.status = "done"
		return
	end

	local dirs = todo_project_dirs(opts.projects)
	local results, pending = {}, #dirs
	if pending == 0 then
		todo_state.status = "done"
		return
	end

	for i, dir in ipairs(dirs) do
		Search.search(function(found)
			results[i] = found
			pending = pending - 1
			if pending > 0 then
				return
			end

			-- Agrupa por arquivo, preservando a ordem dos projetos recentes
			local items, by_file = {}, {}
			for p, dir_results in ipairs(results) do
				local root = dirs[p]
				for _, r in ipairs(dir_results) do
					local file = vim.fs.normalize(r.filename)
					local entry = by_file[file]
					if entry then
						entry.count = entry.count + 1
					elseif #items < opts.limit then
						local kw = Config.options.keywords[r.tag] or {}
						local rel = file:sub(#root + 2)
						entry = {
							file = file,
							count = 1,
							icon = kw.icon or " ",
							label = vim.fn.fnamemodify(root, ":t") .. "/" .. rel,
							lnum = r.lnum,
							col = math.max((r.col or 1) - 1, 0),
						}
						by_file[file] = entry
						items[#items + 1] = entry
					end
				end
			end

			todo_state.items = vim.tbl_map(function(e)
				return {
					icon = e.icon .. " ",
					desc = e.count > 1 and ("%s (%d)"):format(e.label, e.count) or e.label,
					autokey = true,
					action = function()
						vim.cmd.edit(vim.fn.fnameescape(e.file))
						pcall(vim.api.nvim_win_set_cursor, 0, { e.lnum, e.col })
					end,
				}
			end, items)
			todo_state.status = "done"
			Snacks.dashboard.update() -- re-renderiza o dashboard (no-op se já foi fechado)
		end, { cwd = dir, disable_not_found_warnings = true })
	end
end

---@param opts? {projects?:number, limit?:number}
local function todo_projects_section(opts)
	opts = vim.tbl_extend("force", { projects = 5, limit = 8 }, opts or {})
	return function()
		if todo_state.status == "idle" then
			todo_state.status = "loading"
			vim.schedule(function()
				todo_load(opts)
			end)
		end
		if todo_state.status == "loading" then
			return { { icon = "󰔟 ", desc = "Buscando pendências…" } }
		end
		return todo_state.items
	end
end

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
			{ icon = " ", title = "Pendências de Projetos", indent = 2, padding = 1, todo_projects_section() },
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
			local buf = vim.api.nvim_get_current_buf()
			if
				vim.api.nvim_buf_get_name(buf) == ""
				and vim.bo[buf].buftype == ""
				and not vim.bo[buf].modified
				and #vim.fn.getbufinfo({ buflisted = 1 }) == 1
			then
				---@diagnostic disable-next-line: missing-fields
				Snacks.dashboard({ buf = buf, win = 0 })
			end
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
