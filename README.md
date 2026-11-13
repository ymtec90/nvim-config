<div align="center">

#  nvim-config

**Configuração pessoal do Neovim em Lua, focada em desenvolvimento full stack com PHP, Python, JavaScript/TypeScript, Rust, C/C++ e Go.**

![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?style=flat-square&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=flat-square&logo=lua&logoColor=white)
![lazy.nvim](https://img.shields.io/badge/plugins-lazy.nvim-blue?style=flat-square)
![Versão](https://img.shields.io/github/v/tag/ymtec90/nvim-config?style=flat-square&label=vers%C3%A3o)
![Licença](https://img.shields.io/github/license/ymtec90/nvim-config?style=flat-square&label=licen%C3%A7a)

</div>

---

## Sumário

- [Destaques](#-destaques)
- [Requisitos](#-requisitos)
- [Instalação](#-instalação)
- [Estrutura](#-estrutura)
- [Plugins](#-plugins)
- [Linguagens suportadas](#-linguagens-suportadas)
- [Atalhos](#️-atalhos)
- [IA local com CodeCompanion + Ollama](#-ia-local-com-codecompanion--ollama)
- [Comandos personalizados](#-comandos-personalizados)
- [Personalização](#-personalização)
- [Atualização](#-atualização)
- [Licença](#-licença)

---

## ✨ Destaques

- **LSP nativo** com `vim.lsp.config()` / `vim.lsp.enable()` (sem `require("lspconfig").x.setup`), inlay hints automáticos e diagnósticos da linha inteira em janela flutuante ao parar o cursor.
- **Instalação automática de ferramentas** (LSPs, formatadores e debug adapters) via Mason + mason-tool-installer.
- **Formatação ao salvar** com conform.nvim, incluindo _code actions_ automáticas (`fixAll` do ESLint e do Ruff, `organizeImports` do Ruff).
- **PHP com Pint / PHP-CS-Fixer** detectados no `vendor/bin` do projeto, com fallback para o Intelephense.
- **Debug (DAP)** para Python, Go, Rust/C/C++ (codelldb), JavaScript/TypeScript e PHP.
- **Git completo dentro do editor**: Neogit, Diffview, Gitsigns, Lazygit e Octo (issues e PRs do GitHub).
- **IA local** com CodeCompanion + Ollama, com prompts em português para revisar, explicar, gerar código, gerar testes e escrever mensagens de commit.
- **Dashboard** do snacks.nvim com pendências (TODO/FIXME) do projeto.
- **Banco de dados** com vim-dadbod-ui e autocompletar SQL.
- Tema **Gruvbox** com fundo transparente, lualine "evil", bufferline, breadcrumbs (navic) e cursor animado (smear-cursor).

## 📋 Requisitos

| Requisito                                                          | Uso                                                    |
| ------------------------------------------------------------------ | ------------------------------------------------------ |
| [Neovim](https://neovim.io) **0.12+**                              | API nativa de LSP e branch `main` do nvim-treesitter   |
| `git`, `make` e um compilador C (`gcc`/`clang`)                    | lazy.nvim, telescope-fzf-native, parsers do Treesitter |
| [`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter)    | compilação dos parsers (nvim-treesitter `main`)        |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep)                 | `live_grep` do Telescope e busca de pendências         |
| Uma [Nerd Font](https://www.nerdfonts.com)                         | ícones                                                 |
| Node.js + npm                                                      | vários LSPs/formatadores instalados pelo Mason         |
| Python 3 + `pip`                                                   | basedpyright, ruff, debugpy, djlint                    |
| [`lazygit`](https://github.com/jesseduffield/lazygit) _(opcional)_ | `<leader>Gl`                                           |
| [`gh`](https://cli.github.com) autenticado _(opcional)_            | octo.nvim                                              |
| [Ollama](https://ollama.com) _(opcional)_                          | CodeCompanion                                          |

> [!NOTE]
> Algumas ferramentas usadas pela configuração **não** estão na lista do `mason-tool-installer` e precisam ser instaladas à parte (pelo `:Mason` ou pelo gerenciador do sistema): `rust-analyzer` e `djls`.

## 📦 Instalação

Faça backup da configuração atual:

```bash
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

Clone o repositório:

```bash
git clone https://github.com/ymtec90/nvim-config.git ~/.config/nvim
```

Abra o Neovim. O lazy.nvim faz o bootstrap e instala os plugins; o Mason instala as ferramentas em seguida:

```bash
nvim
```

Depois da primeira inicialização, confira a saúde da instalação:

```vim
:checkhealth
:Lazy
:Mason
```

### Testar sem substituir a sua configuração

Use `NVIM_APPNAME` para rodar a configuração isolada:

```bash
git clone https://github.com/ymtec90/nvim-config.git ~/.config/nvim-ymtec
NVIM_APPNAME=nvim-ymtec nvim
```

## 🗂 Estrutura

```text
~/.config/nvim
├── init.lua                 # bootstrap do lazy.nvim, leaders e carga dos módulos
├── .stylua.toml             # estilo do código Lua (StyLua)
└── lua
    ├── options.lua          # opções do editor (vim.opt)
    ├── autocmds.lua         # autocomandos (indentação por linguagem, PHP fixer, limpeza de espaços…)
    ├── mappings.lua         # atalhos gerais, Neogit, Diffview e Octo
    ├── plugin
    │   └── init.lua         # specs de todos os plugins (lazy.nvim)
    └── config               # configuração de cada plugin
        ├── blink.lua
        ├── codecompanion.lua
        ├── conform.lua
        ├── dap.lua
        ├── evil_lualine.lua
        ├── fidget.lua
        ├── lazy.lua
        ├── lspconfig.lua
        ├── navic.lua
        ├── neotree.lua
        ├── rb-delimiters.lua
        ├── smear-cursor.lua
        ├── snacks.lua
        ├── telescope.lua
        └── which-key.lua
```

> O `lazy-lock.json` está no `.gitignore`: os plugins acompanham sempre a versão mais recente.

## 🔌 Plugins

<details>
<summary><b>Interface</b></summary>

| Plugin                                                                                                                  | Função                                                                    |
| ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)                                                             | tema                                                                      |
| [snacks.nvim](https://github.com/folke/snacks.nvim)                                                                     | dashboard, notificações, terminal, lazygit, zen, indent, scratch, toggles |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                                                            | barra de status (estilo _evil_)                                           |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)                                                           | abas de buffers                                                           |
| [breadcrumbs.nvim](https://github.com/LunarVim/breadcrumbs.nvim) + [nvim-navic](https://github.com/SmiteshP/nvim-navic) | breadcrumbs no winbar                                                     |
| [which-key.nvim](https://github.com/folke/which-key.nvim)                                                               | guia de atalhos                                                           |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim)                                                                     | progresso do LSP                                                          |
| [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim)                                                       | animação do cursor                                                        |
| [rainbow-delimiters.nvim](https://github.com/hiphish/rainbow-delimiters.nvim)                                           | parênteses coloridos                                                      |
| [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors)                                          | pré-visualização de cores                                                 |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)                                    | renderização de Markdown no editor                                        |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)                                                       | destaque e navegação de TODO/FIXME                                        |

</details>

<details>
<summary><b>Navegação e arquivos</b></summary>

| Plugin                                                                          | Função                                    |
| ------------------------------------------------------------------------------- | ----------------------------------------- |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) + fzf-native | busca de arquivos, texto, buffers e ajuda |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)                 | explorador de arquivos                    |
| [nvim-file-operations](https://github.com/Crysthamus/nvim-file-operations)      | renomeações refletidas no LSP             |
| [nvim-window-picker](https://github.com/s1n7ax/nvim-window-picker)              | escolha de janela ao abrir arquivos       |
| [yanky.nvim](https://github.com/gbprod/yanky.nvim)                              | histórico de yank com destaque            |

</details>

<details>
<summary><b>LSP, completion e formatação</b></summary>

| Plugin                                                                                                                                       | Função                            |
| -------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                                                                   | configurações base dos servidores |
| [mason.nvim](https://github.com/mason-org/mason.nvim) + [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | instalação de ferramentas         |
| [blink.cmp](https://github.com/saghen/blink.cmp) + friendly-snippets                                                                         | autocompletar e snippets          |
| [conform.nvim](https://github.com/stevearc/conform.nvim)                                                                                     | formatação                        |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main`)                                                               | realce e indentação               |
| [SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim)                                                                                  | schemas para JSON e YAML          |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim)                                                                                        | tipos da API do Neovim para Lua   |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) / [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)                    | fechamento de pares e tags        |

</details>

<details>
<summary><b>Git e GitHub</b></summary>

| Plugin                                                      | Função                                        |
| ----------------------------------------------------------- | --------------------------------------------- |
| [neogit](https://github.com/NeogitOrg/neogit)               | interface do Git (status, commit, push, pull) |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim)  | diffs, histórico e resolução de conflitos     |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | alterações na signcolumn                      |
| [octo.nvim](https://github.com/pwntester/octo.nvim)         | issues e pull requests do GitHub              |

</details>

<details>
<summary><b>Debug, banco de dados, web e IA</b></summary>

| Plugin                                                                                              | Função                                         |
| --------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) + dap-ui, dap-virtual-text, dap-python, dap-go | debug                                          |
| [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui)                                    | cliente de banco de dados                      |
| [live-preview.nvim](https://github.com/brianhuster/live-preview.nvim)                               | pré-visualização de HTML/Markdown no navegador |
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)                               | assistente de IA com Ollama                    |

</details>

## 🧰 Linguagens suportadas

| Linguagem                     | LSP                          | Formatação                           | Debug             |
| ----------------------------- | ---------------------------- | ------------------------------------ | ----------------- |
| PHP / Laravel Blade           | intelephense, html           | Pint / PHP-CS-Fixer, blade-formatter | php-debug-adapter |
| Python / Django               | basedpyright, ruff, djls     | ruff, djlint                         | debugpy           |
| JavaScript / TypeScript / Vue | vtsls, eslint                | prettierd                            | js-debug-adapter  |
| HTML / CSS / SCSS             | html, cssls, emmet_ls        | prettierd                            | —                 |
| Rust                          | rust_analyzer (clippy)       | rustfmt (via LSP)                    | codelldb          |
| C / C++                       | clangd (clang-tidy)          | clang-format (via LSP)               | codelldb          |
| Go                            | gopls (gofumpt, staticcheck) | via LSP                              | delve             |
| Lua                           | lua_ls                       | stylua                               | —                 |
| JSON / YAML / TOML            | jsonls, yamlls, taplo        | prettierd, taplo                     | —                 |

Indentação por linguagem: **4 espaços** por padrão, **2 espaços** para web/JSON/YAML e **tabs** para Go. Régua (`colorcolumn`) em 88 colunas para Python, 120 para PHP e 100 para Rust.

## ⌨️ Atalhos

`<leader>` = <kbd>Espaço</kbd> · `<localleader>` = <kbd>,</kbd>. Pressione <kbd>Espaço</kbd> e aguarde para o which-key mostrar todos os grupos.

### Gerais

| Atalho                      | Modo | Ação                                     |
| --------------------------- | ---- | ---------------------------------------- |
| `;`                         | n    | entrar no modo de comando                |
| `jj`                        | i    | sair do modo insert                      |
| `<Tab>` / `<S-Tab>`         | n    | próximo / anterior buffer                |
| `J` / `K`                   | v    | mover seleção para baixo / cima          |
| `Y`                         | n    | copiar até o fim da linha                |
| `]t` / `[t`                 | n    | próximo / anterior TODO                  |
| `]]` / `[[`                 | n    | próxima / anterior referência do símbolo |
| `<leader>bd` / `<leader>bo` | n    | fechar buffer / fechar os outros         |
| `<leader>t`                 | n    | terminal                                 |
| `<leader>z`                 | n    | modo zen                                 |
| `<leader>.`                 | n    | scratch buffer                           |
| `<leader>n` / `<leader>un`  | n    | histórico / fechar notificações          |
| `<leader>lp`                | n    | Live Preview                             |

> As setas estão desativadas no modo normal.

### Busca (Telescope) e explorador

| Atalho       | Ação                              |
| ------------ | --------------------------------- |
| `<leader>ff` | arquivos                          |
| `<leader>fg` | live grep                         |
| `<leader>fb` | buffers abertos                   |
| `<leader>fo` | arquivos recentes                 |
| `<leader>fh` | ajuda                             |
| `<leader>e`  | abrir/fechar Neo-tree             |
| `<leader>o`  | revelar arquivo atual no Neo-tree |
| `<leader>F`  | Neo-tree flutuante                |

### Código, LSP e diagnósticos

| Atalho                    | Ação                                                 |
| ------------------------- | ---------------------------------------------------- |
| `gd` / `gD` / `gI` / `gR` | definição / declaração / implementação / referências |
| `K`                       | documentação (hover)                                 |
| `<leader>cA`              | code action                                          |
| `<leader>cr`              | renomear símbolo                                     |
| `<leader>cf`              | formatar                                             |
| `<leader>xd`              | diagnóstico flutuante                                |
| `<leader>xq`              | diagnósticos no quickfix                             |

### Debug (DAP)

| Atalho                                     | Ação                         |
| ------------------------------------------ | ---------------------------- |
| `<leader>db`                               | alternar breakpoint          |
| `<leader>dc`                               | iniciar / continuar          |
| `<leader>di` / `<leader>do` / `<leader>dO` | step into / over / out       |
| `<leader>dC`                               | rodar até o cursor           |
| `<leader>de`                               | avaliar expressão            |
| `<leader>dr`                               | REPL                         |
| `<leader>du`                               | interface                    |
| `<leader>dT`                               | depurar o teste sob o cursor |
| `<leader>dt`                               | encerrar                     |

### Git e GitHub

| Atalho                                     | Ação                             |
| ------------------------------------------ | -------------------------------- |
| `<leader>Gs`                               | status (Neogit)                  |
| `<leader>Gc` / `<leader>Gp` / `<leader>GP` | commit / pull / push             |
| `<leader>Gd` / `<leader>Gq`                | abrir / fechar Diffview          |
| `<leader>Gh` / `<leader>GH`                | histórico do arquivo / do branch |
| `<leader>Gl`                               | lazygit                          |
| `<leader>Gb`                               | abrir no GitHub                  |
| `<leader>GA`                               | gerar mensagem de commit com IA  |
| `<leader>Op` / `<leader>Oi` / `<leader>Os` | PRs / issues / pesquisa (Octo)   |

### Alternâncias (`<leader>u`)

| Atalho       | Ação                |
| ------------ | ------------------- |
| `<leader>uw` | quebra de linha     |
| `<leader>uL` | número relativo     |
| `<leader>ud` | diagnósticos        |
| `<leader>uh` | inlay hints         |
| `<leader>ug` | guias de indentação |
| `<leader>uT` | Treesitter          |
| `<leader>uD` | dim                 |

## 🤖 IA local com CodeCompanion + Ollama

O CodeCompanion usa um modelo local servido pelo Ollama em `http://localhost:11434`. O modelo padrão é `bonsai2:nvim` com contexto de 4096 tokens — altere `MODEL` e `NUM_CTX` em `lua/config/codecompanion.lua` para usar outro.

```bash
ollama serve
ollama pull <modelo>   # ou crie o seu com: ollama create bonsai2:nvim -f Modelfile
```

| Atalho       | Modo | Ação                                               |
| ------------ | ---- | -------------------------------------------------- |
| `<leader>Ic` | n, v | abrir/fechar o chat                                |
| `<leader>Ia` | n, v | menu de ações                                      |
| `<leader>IA` | v    | enviar a seleção ao chat                           |
| `<leader>GA` | n    | mensagem de commit a partir do `git diff --staged` |

Prompts disponíveis no chat (slash commands): `/revisar`, `/explicar`, `/gerar`, `/testes` e `/commit_padrao`.

## 🛠 Comandos personalizados

| Comando          | Descrição                                                           |
| ---------------- | ------------------------------------------------------------------- |
| `:PHPFix`        | salva o arquivo PHP e roda Pint / PHP-CS-Fixer                      |
| `:CleanWSToggle` | liga/desliga a remoção de espaços no fim das linhas no buffer atual |

## 🎨 Personalização

- **Adicionar um plugin:** crie uma nova entrada em `lua/plugin/init.lua` e, se a configuração for longa, um módulo em `lua/config/<plugin>.lua`.
- **Adicionar um LSP:** inclua o nome em `servers` em `lua/config/lspconfig.lua` (e, se necessário, um `vim.lsp.config.<nome> = { ... }`) e a ferramenta em `ensure_installed` do mason-tool-installer.
- **Adicionar um formatador:** edite `formatters_by_ft` em `lua/config/conform.lua`.
- **Estilo do código Lua:** siga o `.stylua.toml` (`stylua .`).

## 🔄 Atualização

```bash
cd ~/.config/nvim
git pull
nvim --headless "+Lazy! sync" +qa
```

Dentro do Neovim: `:Lazy sync`, `:MasonToolsUpdate` e `:TSUpdate`.

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE).
