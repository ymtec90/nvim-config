local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },

    mappings = {
      i = {
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
      },
      n = {
        ["q"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true, -- Mostrar arquivos ocultos (ex: .gitignore ignorados ou dotfiles)
      file_ignore_patterns = { "node_modules", ".git/" },
    },
  },
  extensions = {
    -- Configurações de extensões (ex: fzf, live_grep_args, etc) vão aqui
  },
})

-- Atalhos de teclado comuns (Keymaps)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
