-- Truecolor.
if vim.fn.exists("+termguicolors") == 1 then
  if vim.fn.has("nvim") == 0 then
    vim.opt.t_8f = "\\[38;2;%lu;%lu;%lum"
    vim.opt.t_8b = "\\[48;2;%lu;%lu;%lum"
  end
  vim.opt.termguicolors = true
end

-- Evita que o conceallevel esconda as aspas no JSON
vim.opt.conceallevel = 0
vim.g.vim_json_conceal = 0
vim.g.vim_json_syntax_conceal = 0

-- Habilita a numeração de linhas e o cursorline
vim.opt.number = true
vim.opt.cursorline = true

-- Indentação padrão: 4 espaços
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Reduz o tempo de resposta do CursorHold
vim.opt.updatetime = 300

-- Sempre exibe a signcolumn
vim.opt.signcolumn = "yes"

vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.history = 1000
vim.opt.laststatus = 2
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Recarrega o arquivo quando ele muda fora do Vim
vim.opt.autoread = true

-- Timeouts
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 50

vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.wildignore = {
  "*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx",
  "*/node_modules/*", "*/.git/*", "*/__pycache__/*", "*/.venv/*", "*/target/*"
}

-- Clipboard: no macOS 'unnamed', caso contrário 'unnamedplus'
if vim.fn.has("mac") == 1 then
  vim.opt.clipboard = "unnamed"
else
  vim.opt.clipboard = "unnamedplus"
end

-- Altera os símbolos para diagnóstico
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
})

