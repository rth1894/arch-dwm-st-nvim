local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

map("n", "<Esc>", "<cmd>nohlsearch<cr>")

map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

map("n", "<A-j>", "<cmd>vertical resize -2<cr>")
map("n", "<A-k>", "<cmd>vertical resize +2<cr>")

map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<C-j>", "<C-w>h")
map("n", "<C-k>", "<C-w>l")

map("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '0', 'g0')
vim.keymap.set('n', '$', 'g$')

vim.keymap.set("n", "<leader>sn", function() require("snacks").picker.files({ cwd = vim.fn.stdpath("config"),})
end, { desc = "Search nvim config files" })

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>")
