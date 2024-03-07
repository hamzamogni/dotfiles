local map = vim.keymap.set
local builtin = require('telescope.builtin')


-- map('n', '<leader>ss', function()
--     builtin.grep_string({ search = vim.fn.input("Grep > ") });
-- end)


map('n', '<leader>sf', function() builtin.find_files({ hidden = true }) end, {})
map('n', '<C-p>', builtin.git_files, {})
map('n', '<leader>s/', builtin.live_grep, {})
map('n', '<leader>sb', builtin.buffers, {})
map('n', '<leader>sh', builtin.help_tags, {})
map('n', '<leader>man', builtin.man_pages, {})


-- Search vim config files from wherever you are
-- I can use this to lookup shortcuts I have set...etc.
-- TODO: STILL NOT WORKING AS EXPECTED
map('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]eartch [N]eovim files' })
