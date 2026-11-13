local MODEL = "bonsai2:nvim"
local NUM_CTX = 4096
local MAX_CHARS = 6000

-- Corta o texto se ele não couber no contexto e avisa
---@param text string
---@param what string
---@return string
local function caber(text, what)
	if #text <= MAX_CHARS then
		return text
	end
	vim.notify(
		string.format("[IA] %s truncado: %d → %d caracteres (contexto de %d tokens)", what, #text, MAX_CHARS, NUM_CTX),
		vim.log.levels.WARN
	)
	return text:sub(1, MAX_CHARS) .. "\n... [truncado]"
end

-- Instrução + seleção visual num bloco com o filetype do buffer.
---@param instrucao string
local function com_codigo(instrucao)
	return function(context)
		local code = require("codecompanion.helpers.code").get_code(context.start_line, context.end_line)
		return string.format("%s\n\n```%s\n%s\n```", instrucao, context.filetype, caber(code, "Trecho"))
	end
end

require("codecompanion").setup({
	adapters = {
		http = {
			bonsai = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "bonsai",
					formatted_name = "Bonsai 2 2B (local)",
					env = { url = "http://localhost:11434" },
					schema = {
						model = { default = MODEL },
						num_ctx = { default = NUM_CTX },
						think = { default = false }, -- thinking consome o contexto e pode devolver resposta vazia
						keep_alive = { default = "10m" }, -- libera a RAM depois de 10 min parado (8 GB no Hackintosh)
						temperature = { default = 0.2 },
					},
				})
			end,
		},
	},

	interactions = {
		chat = {
			adapter = "bonsai",
			opts = {
				-- Substitui o system prompt padrão do plugin, que sozinho ocupa boa parte de 4096 tokens.
				system_prompt = function()
					return [[Você é um engenheiro de software e cientista de dados auxiliando uma equipe técnica, com foco em desenvolvimento, análise de dados e sistemas de suprimento de bens e serviços.
Suas respostas devem ser diretas, altamente técnicas e estritamente em português do Brasil.
Sempre priorize eficiência computacional, boas práticas em Python/Bash e legibilidade no código.
Código sempre em blocos markdown com a linguagem indicada.]]
				end,
			},
		},
		inline = { adapter = "bonsai" },
		cmd = { adapter = "bonsai" },
	},

	-- AGENTS.md, CLAUDE.md, .cursorrules etc. iriam junto em todo chat e estourariam o contexto.
	rules = {
		opts = {
			chat = { enabled = false },
		},
	},

	opts = {
		language = "Portuguese (Brazil)",
		-- log_level = "DEBUG", -- depuração: :CodeCompanionLog
	},

	prompt_library = {
		["commit_padrao"] = {
			interaction = "chat",
			description = "Gera uma mensagem de commit seguindo o padrão rígido da equipe",
			opts = {
				alias = "commit_padrao",
				is_slash_cmd = true,
				auto_submit = true,
			},
			prompts = {
				{
					role = "system",
					content = [[Você é um gerador de mensagens de commit de código.
Você deve analisar o git diff fornecido e gerar uma mensagem de commit ESTRITAMENTE neste formato:

<TIPO>(<ESCOPO>): <Descrição curta no imperativo em português>

Tipos permitidos pela equipe:
- feat (nova funcionalidade, modelo ou integração)
- fix (correção de bug em script ou pipeline)
- docs (atualização de documentação)
- refactor (otimização de código estrutural)
- chore (atualizações de pacotes, configurações no Neovim/Linux)

Exemplo de saída esperada:
feat(analytics): adiciona cálculo de probabilidade histórica no painel principal

Regra de Ouro: Retorne APENAS a mensagem de commit final. Não adicione saudações, não explique o diff e não use blocos de código markdown. Apenas o texto plano.]],
				},
				{
					role = "user",
					content = function()
						local diff = vim.fn.system({ "git", "diff", "--no-ext-diff", "--staged" })
						if vim.v.shell_error ~= 0 or diff == "" then
							return "Não há alterações em stage. Responda apenas: nada em stage."
						end
						-- O --stat vem antes para o modelo ver todos os arquivos mesmo se o diff for cortado.
						local stat = vim.fn.system({ "git", "diff", "--staged", "--stat" })
						return "Gere a mensagem de commit para o seguinte diff:\n\n"
							.. stat
							.. "\n"
							.. caber(diff, "Diff")
					end,
				},
			},
		},

		["Revisar código"] = {
			interaction = "chat",
			description = "Revisa a seleção: bugs, segurança, desempenho, legibilidade",
			opts = {
				alias = "revisar",
				is_slash_cmd = true,
				modes = { "v" },
				auto_submit = true,
				stop_context_insertion = true,
			},
			prompts = {
				{
					role = "user",
					content = com_codigo(
						"Revise o código abaixo. Liste, do mais grave para o menos grave: bugs, segurança, "
							.. "desempenho e legibilidade. Para cada item, cite a linha e mostre a correção."
					),
				},
			},
		},

		["Explicar código"] = {
			interaction = "chat",
			description = "Explica a seleção passo a passo",
			opts = {
				alias = "explicar",
				is_slash_cmd = true,
				modes = { "v" },
				auto_submit = true,
				stop_context_insertion = true,
			},
			prompts = {
				{
					role = "user",
					content = com_codigo(
						"Explique este código: resumo em uma frase, depois o fluxo passo a passo e pontos de atenção."
					),
				},
			},
		},

		["Gerar código"] = {
			interaction = "inline",
			description = "Substitui a seleção (comentário/esboço) pelo código implementado",
			opts = { alias = "gerar", modes = { "v" }, placement = "replace", stop_context_insertion = true },
			prompts = {
				{
					role = "user",
					content = com_codigo(
						"Implemente o que está descrito no trecho abaixo (comentário ou esboço). "
							.. "Devolva apenas o código final, sem explicações."
					),
				},
			},
		},

		["Gerar testes"] = {
			interaction = "chat",
			description = "Gera testes unitários para a seleção",
			opts = {
				alias = "testes",
				is_slash_cmd = true,
				modes = { "v" },
				auto_submit = true,
				stop_context_insertion = true,
			},
			prompts = {
				{
					role = "user",
					content = function(context)
						local fw = ({
							python = "pytest",
							php = "PHPUnit",
							rust = "#[cfg(test)] com cargo test",
							go = "o pacote testing",
							lua = "busted",
							javascript = "vitest",
							typescript = "vitest",
							c = "Unity",
						})[context.filetype] or "o framework de testes padrão da linguagem"
						return com_codigo(
							"Escreva testes unitários com "
								.. fw
								.. " para o código abaixo: caminho feliz, casos de borda e erros. "
								.. "Devolva um único bloco de código pronto para rodar."
						)(context)
					end,
				},
			},
		},
	},
})
