local map = vim.keymap.set

-- normal mode mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "o", "o<ESC>", { desc = "Insert line below" })
map("n", "O", "O<ESC>", { desc = "Insert line above" })
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "Y", "y$", { desc = "Copy the rest of the line" })
map("n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "<Up>", "")
map("n", "<Down>", "")
map("n", "<Right>", "")
map("n", "<Left>", "")

-- insert mode mappings
map("i", "jj", "<ESC>")

-- visual mode mappings
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Neogit (Gestão do Repositório)
map("n", "<leader>gs", "<cmd>Neogit<CR>", { desc = "Git Status (Neogit)" })
map("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "Git Commit (Neogit)" })
map("n", "<leader>gp", "<cmd>Neogit pull<CR>", { desc = "Git Pull (Neogit)" })
map("n", "<leader>gP", "<cmd>Neogit push<CR>", { desc = "Git Push (Neogit)" })

-- Diffview (Análise de Código e Histórico)
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Git Diffview (Abrir)" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Git Histórico do Arquivo" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Git Histórico do Branch" })
map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Git Diffview (Fechar)" })

-- Octo (Integração com GitHub)
map("n", "<leader>op", "<cmd>Octo pr list<CR>", { desc = "Octo Listar Pull Requests" })
map("n", "<leader>oi", "<cmd>Octo issue list<CR>", { desc = "Octo Listar Issues" })
map("n", "<leader>os", "<cmd>Octo search<CR>", { desc = "Octo Pesquisar no Repositório" })
