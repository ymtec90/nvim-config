local dap = require("dap")
local utils = require("dap.utils")

-- Interface
local dapui = require("dapui")
dapui.setup()
require("nvim-dap-virtual-text").setup({ commented = true })

-- Abre a interface ao iniciar e fecha ao terminar a sessão
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

-- Utilitários --------------------------------------------------------------------

local function ask_args()
	return vim.split(vim.fn.input("Argumentos: "), " ", { trimempty = true })
end

-- Escolha assíncrona dentro da coroutine em que o nvim-dap avalia as configs
local function select_async(items, prompt)
	local co = coroutine.running()
	vim.ui.select(items, { prompt = prompt }, function(choice)
		vim.schedule(function()
			coroutine.resume(co, choice or dap.ABORT)
		end)
	end)
	return coroutine.yield()
end

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
local function bin(name)
	local exe = vim.fn.exepath(name)
	return exe ~= "" and exe or mason_bin .. name
end

-- C, C++ e Rust — codelldb
dap.adapters.codelldb = { type = "executable", command = bin("codelldb") }

local c_family = {
	{
		name = "Executar binário",
		type = "codelldb",
		request = "launch",
		program = function()
			return utils.pick_file({ executables = true })
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
	{
		name = "Executar binário (com argumentos)",
		type = "codelldb",
		request = "launch",
		program = function()
			return utils.pick_file({ executables = true })
		end,
		args = ask_args,
		cwd = "${workspaceFolder}",
	},
	{
		name = "Anexar a um processo",
		type = "codelldb",
		request = "attach",
		pid = utils.pick_process,
	},
}
dap.configurations.c = c_family
dap.configurations.cpp = c_family

-- Rust: compila com cargo e oferece os binários gerados
local function cargo_build()
	vim.notify("cargo build…")
	local res = vim.system({ "cargo", "build", "--message-format=json" }, { text = true }):wait()
	if res.code ~= 0 then
		vim.notify("cargo build falhou:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
		return dap.ABORT
	end
	local bins = {}
	for line in res.stdout:gmatch("[^\n]+") do
		local ok, msg = pcall(vim.json.decode, line)
		if
			ok
			and msg.reason == "compiler-artifact"
			and type(msg.executable) == "string"
			and vim.tbl_contains(msg.target.kind, "bin")
		then
			table.insert(bins, msg.executable)
		end
	end
	if #bins == 0 then
		vim.notify("Nenhum binário gerado", vim.log.levels.WARN)
		return dap.ABORT
	end
	return #bins == 1 and bins[1] or select_async(bins, "Binário: ")
end

dap.configurations.rust = {
	{
		name = "Cargo: compilar e executar",
		type = "codelldb",
		request = "launch",
		program = cargo_build,
		cwd = "${workspaceFolder}",
		sourceLanguages = { "rust" }, -- formatadores de Vec, String, Option…
	},
	{
		name = "Cargo: compilar e executar (com argumentos)",
		type = "codelldb",
		request = "launch",
		program = cargo_build,
		args = ask_args,
		cwd = "${workspaceFolder}",
		sourceLanguages = { "rust" },
	},
	vim.tbl_extend("force", c_family[3], { sourceLanguages = { "rust" } }),
}

-- Go — Delve (nvim-dap-go cria Debug, Debug test, Attach, etc.)
require("dap-go").setup({
	delve = { path = bin("dlv") },
})

-- Python e Django — debugpy
-- O debugpy roda no venv do Mason; o programa usa o venv do projeto
-- ($VIRTUAL_ENV, .venv ou venv), detectado pelo nvim-dap-python.
local dap_python = require("dap-python")
dap_python.setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
dap_python.test_runner = "pytest"

vim.list_extend(dap.configurations.python, {
	{
		name = "Django: runserver",
		type = "python",
		request = "launch",
		program = "${workspaceFolder}/manage.py",
		args = { "runserver", "--noreload" },
		django = true,
		justMyCode = true,
		console = "integratedTerminal",
	},
	{
		name = "Django: test",
		type = "python",
		request = "launch",
		program = "${workspaceFolder}/manage.py",
		args = function()
			return vim.list_extend({ "test" }, ask_args())
		end,
		django = true,
		justMyCode = true,
	},
})

-- JavaScript e TypeScript — vscode-js-debug (Node e Chrome)
for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
	dap.adapters[adapter] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = { command = bin("js-debug-adapter"), args = { "${port}" } },
	}
end

-- launch.json do VSCode costuma usar "node"/"chrome"; redireciona para pwa-*
for _, alias in ipairs({ "node", "chrome" }) do
	dap.adapters[alias] = function(cb, config)
		config.type = "pwa-" .. alias
		local native = dap.adapters[config.type]
		if type(native) == "function" then
			native(cb, config)
		else
			cb(native)
		end
	end
end

local js_skip = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" }
local js_configs = {
	{
		name = "Node: arquivo atual",
		type = "pwa-node",
		request = "launch",
		program = "${file}", -- .ts roda direto no Node 22.18+/23.6+ (type stripping)
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		skipFiles = js_skip,
		console = "integratedTerminal",
	},
	{
		name = "Node: script do package.json",
		type = "pwa-node",
		request = "launch",
		runtimeExecutable = "npm",
		runtimeArgs = function()
			return { "run", vim.fn.input("Script: ", "dev") }
		end,
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		skipFiles = js_skip,
		console = "integratedTerminal",
	},
	{
		name = "Node: anexar a um processo (--inspect)",
		type = "pwa-node",
		request = "attach",
		processId = utils.pick_process,
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		skipFiles = js_skip,
	},
	{
		name = "Chrome: abrir URL",
		type = "pwa-chrome",
		request = "launch",
		url = function()
			return vim.fn.input("URL: ", "http://localhost:5173")
		end,
		webRoot = "${workspaceFolder}",
		sourceMaps = true,
	},
}
for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }) do
	dap.configurations[ft] = js_configs
end

-- PHP — Xdebug 3 via vscode-php-debug
-- Requer no php.ini: xdebug.mode=debug  e  xdebug.start_with_request=yes
-- (ou o cookie/extensão XDEBUG_SESSION no navegador). Porta padrão: 9003.
dap.adapters.php = { type = "executable", command = bin("php-debug-adapter") }

dap.configurations.php = {
	{
		name = "Xdebug: escutar (local / php artisan serve)",
		type = "php",
		request = "launch",
		port = 9003,
	},
	{
		name = "Xdebug: escutar (Laravel Sail / Docker)",
		type = "php",
		request = "launch",
		port = 9003,
		pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
	},
	{
		name = "PHP: script atual (CLI)",
		type = "php",
		request = "launch",
		program = "${file}",
		cwd = "${fileDirname}",
		port = 0,
		runtimeArgs = { "-dxdebug.start_with_request=yes" },
		env = { XDEBUG_MODE = "debug,develop", XDEBUG_CONFIG = "client_port=${port}" },
	},
}

-- Tipos do launch.json -> filetypes em que aparecem
local js_fts = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }
require("dap.ext.vscode").type_to_filetypes = {
	node = js_fts,
	chrome = js_fts,
	["pwa-node"] = js_fts,
	["pwa-chrome"] = js_fts,
	codelldb = { "c", "cpp", "rust" },
	python = { "python" },
	debugpy = { "python" },
	go = { "go" },
	delve = { "go" },
	php = { "php", "blade" },
}
