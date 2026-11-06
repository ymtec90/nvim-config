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
