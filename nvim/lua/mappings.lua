local map = vim.keymap.set

-- Get out of insert mode
map("i", "jj", "<Esc>")

-- Move between windows
map('', '<leader>ww', ':wincmd w<cr>')
map('', '<leader>wh', ':wincmd h<cr>')
map('', '<leader>wj', ':wincmd j<cr>')
map('', '<leader>wk', ':wincmd k<cr>')
map('', '<leader>wl', ':wincmd l<cr>')
