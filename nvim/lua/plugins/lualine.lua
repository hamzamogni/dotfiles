require('lualine').setup {
  options = {
    theme = 'tokyonight'
  },
  sections = {
    lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },
    lualine_b = {'branch', 'diff', 
      { 'diagnostics', sources = { 'nvim_diagnostic', 'nvim_lsp' } }
    },
    lualine_c = {
      { 'filename', path = 3 },
    },
    lualine_y = {},
    lualine_z = { 'location' }
  }
}
