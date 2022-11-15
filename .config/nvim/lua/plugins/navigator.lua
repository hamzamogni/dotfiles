local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'navigator'.setup({
  mason = true,
  lsp = {
    -- disable_lsp = {"pyright"},
    capabilities = capabilities,

    pylsp = { 
      settings = {
        pylsp = {
          configurationSources = { "flake8" },
          plugins = {
            flake8 = { enabled = true },
            black = { enabled = true },

            pyflake = { enabled = false },
            mccabe = { enabled = false },
            pycodestyle = { enabled = false },
          },
        },
      }
    },

  }
})
