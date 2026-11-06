-- Define as configurações específicas para o Lua ANTES de habilitá-lo
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
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
            },
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
}

-- Lista de servidores a serem ativados
local servers = {
  "html",
  "cssls",
  "basedpyright",
  "ts_ls",
  "emmet_ls",
  "lua_ls",
}

-- Injeta os mapeamentos e recursos (capabilities) nativamente aqui
vim.lsp.enable(servers)
