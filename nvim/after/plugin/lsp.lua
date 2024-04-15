local map = vim.keymap.set

local lsp = require('lsp-zero')
lsp.preset("recommended")

require('luasnip.loaders.from_vscode').lazy_load()
local luasnip = require('luasnip')

map({"i", "s"}, "<C-K>", function() luasnip.expand() end, {silent = true})
map({"i", "s"}, "<C-L>", function() luasnip.jump( 1) end, {silent = true})
map({"i", "s"}, "<C-J>", function() luasnip.jump(-1) end, {silent = true})

lsp.ensure_installed({
    "gopls",
    "tsserver",
    "pylsp",
    "lua_ls",
    "rust_analyzer",
    "clangd",
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I',
    }
})

---@diagnostic disable-next-line: unused-local
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    map('n', "gd", function() vim.lsp.buf.definition() end, opts)
    map('n', "K", function() vim.lsp.buf.hover() end, opts)
    map('n', "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    map('n', "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    map('n', "[d", function() vim.diagnostic.goto_next() end, opts)
    map('n', "]d", function() vim.diagnostic.goto_prev() end, opts)
    map('n', "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    map('n', "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    map('n', "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    map('n', "<leader>ff", function() vim.lsp.buf.format() end, opts)
    map('i', "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
