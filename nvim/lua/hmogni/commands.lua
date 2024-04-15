-- vim.cmd([[autocmd FileType markdown setlocal spell]])
-- 
-- -- go to last loc when opening a buffer
-- vim.api.nvim_create_autocmd("BufReadPre", {
--     pattern = "*",
--     callback = function()
--         vim.api.nvim_create_autocmd("FileType", {
--             pattern = "<buffer>",
--             once = true,
--             callback = function()
--                 vim.cmd(
--                     [[if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]]
--                 )
--             end,
--         })
--     end,
-- })

-- Highlight on yank
vim.cmd("au TextYankPost * lua vim.highlight.on_yank {}")
