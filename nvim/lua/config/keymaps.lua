local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

map("n", "<Esc>", "<cmd>nohlsearch<cr>")

map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<C-Up>", "<cmd>resize +2<cr>")
map("n", "<C-Down>", "<cmd>resize -2<cr>")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

map("v", "<", "<gv")
map("v", ">", ">gv")

map("t", "<Esc><Esc>", "<C-\\><C-n>")
