require("codecompanion").setup({
	strategies = {
		chat = { adapter = "ollama" },
		inline = { adapter = "ollama" },
		agent = { adapter = "ollama" },
	},
	adapters = {
		ollama = function()
			return require("codecompanion.adapters").extend("ollama", {
				name = "ollama",
				env = {
					url = "http://localhost:11434",
				},
				headers = {
					["Content-Type"] = "application/json",
				},
				parameters = {
					sync = true,
				},
				schema = {
					model = {
						default = "qwen2.5-coder:1.5b",
					},
					num_ctx = {
						default = 8192,
					},
				},
			})
		end,
	},

	system_prompt = function()
		return [[Você é um engenheiro de software e cientista de dados auxiliando uma equipe técnica, com foco em desenvolvimento, análise de dados e sistemas de suprimento de bens e serviços.
            Suas respostas devem ser diretas, altamente técnicas e estritamente em português do Brasil.
            Sempre priorize eficiência computacional, boas práticas em Python/Bash e legibilidade no código.]]
	end,

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
						return "Gere a mensagem de commit para o seguinte diff:\n\n"
							.. vim.fn.system("git diff --staged")
					end,
				},
			},
		},
	},
})
