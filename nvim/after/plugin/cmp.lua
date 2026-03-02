local map = vim.keymap.set

local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
local cmp = require('cmp')

map({ "i", "s" }, "<C-K>", function() luasnip.expand() end, { silent = true })
map({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() luasnip.jump(-1) end, { silent = true })


local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
})
