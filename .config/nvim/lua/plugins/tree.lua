-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup({
  sort_by = "name",
  disable_netrw = true,
  update_focused_file = {
      enable = true,
  },
  filters = {
    dotfiles = false,
  },
  view = {
    width = 25,
    adaptive_size = true,
    mappings = {
      custom_only = false,
      list = {
        -- Add mappings here
      }
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  },
  renderer = {
      group_empty = true,
  }
})

vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<cr>')
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<cr>')
vim.keymap.set('n', '<leader>t', ':NvimTreeFocus<cr>')
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<cr>')
