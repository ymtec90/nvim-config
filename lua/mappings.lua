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
