require'packer'.startup(function (use)
  use 'wbthomason/packer.nvim'
  
  use 'editorconfig/editorconfig-vim'
  use 'junegunn/vim-plug'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use 'sheerun/vim-polyglot'
  use 'tpope/vim-fugitive'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use 'deoplete-plugins/deoplete-clang'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'kylechui/nvim-surround'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'

  use 'vim-pandoc/vim-pandoc'
  use 'vim-pandoc/vim-pandoc-syntax'
  
  -- For vsnip users.
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  
  -- navigator
  use { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' }
  use 'ray-x/navigator.lua'
  
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  
  -- telescope
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  
  -- theme
  use "folke/tokyonight.nvim"

end)

require('theme')
require('mappings')
require('settings')

require('plugins.telescope')
require('plugins.cmp')
require('plugins.mason')
require('plugins.navigator')
require('plugins.tree')
require('plugins.lualine')
require('plugins.others')

