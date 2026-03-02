local map = vim.keymap.set

require('mason').setup({})
require("mason-lspconfig").setup {
    "gopls",
    "ts_ls",
    "pylsp",
    "lua_ls",
    "rust_analyzer",
    "clangd",
}

-- Fix Undefined global 'vim'
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        map('n', "gd", vim.lsp.buf.definition)
        map('n', "K", vim.lsp.buf.hover)
        map('n', "<leader>vws", vim.lsp.buf.workspace_symbol)
        map('n', "<leader>vd", vim.diagnostic.open_float)
        map('n', "[d", vim.diagnostic.goto_next)
        map('n', "]d", vim.diagnostic.goto_prev)
        map('n', "<leader>vca", vim.lsp.buf.code_action)
        map('n', "<leader>vrr", vim.lsp.buf.references)
        map('n', "<leader>vrn", vim.lsp.buf.rename)
        map('n', "<leader>ff", vim.lsp.buf.format)
        map('i', "<C-h>", vim.lsp.buf.signature_help)
    end,
})

vim.diagnostic.config({
    virtual_text = true
})
