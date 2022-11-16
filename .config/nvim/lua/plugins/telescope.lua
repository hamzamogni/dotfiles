local map = vim.keymap.set
local builtin = require('telescope.builtin')

map('n', '<leader>ff', function() builtin.find_files({ hidden = true }) end, {})
map('n', '<leader>fg', builtin.live_grep, {})
map('n', '<leader>fb', builtin.buffers, {})
map('n', '<leader>fh', builtin.help_tags, {})
map('n', '<leader>man', builtin.man_pages, {})
