vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>pv", vim.cmd.Ex)

-- Get out of insert mode
map("i", "jj", "<Esc>")

-- Move between windows
map('', '<leader>ww', ':wincmd w<cr>')
map('', '<leader>wh', ':wincmd h<cr>')
map('', '<leader>wj', ':wincmd j<cr>')
map('', '<leader>wk', ':wincmd k<cr>')
map('', '<leader>wl', ':wincmd l<cr>')

-- Replace selection block with clipboard content
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank selection to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- yank line to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])


vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/scripts/tmux-sessionizer<CR>")
