local opt = vim.opt

opt.autoread = true -- Set to auto read when a file is changed from the outside
opt.undofile = true -- Persistent
opt.clipboard = "unnamedplus"
opt.backup = false -- don't make backup before overwriting file

-- FOLDING
opt.foldenable = true -- Enable folding
opt.foldlevel = 0 -- Close all folds by default
opt.foldmethod = "syntax" -- Syntax are used to specify folds
opt.foldminlines = 0 -- Allow folding single lines
opt.foldnestmax = 5 -- Set max fold nesting level
opt.foldcolumn = "0" -- Column to show folds

-- INDENTATIONS
opt.expandtab = true -- Expand tabs to spaces
opt.shiftwidth = 4 -- The # of spaces for indenting
opt.softtabstop = 4

-- TABS
opt.showtabline = 2 -- Always show tab bar

-- SEARCH 
opt.hlsearch = true -- Highlight searches
opt.incsearch = true -- Highlight dynamically as pattern is typed
opt.ignorecase = true -- Ignore case in search patterns.
opt.smartcase = true -- Ignore 'ignorecase' if search patter contains uppercase characters


-- APPEARENCE
opt.wrap = false -- Do not wrap lines
opt.showmode = false -- Do not show mode (will be taken care of by lightline)

-- EXTRAS
opt.cursorline = true -- Highlight current line

opt.wildmode = 'list:full' -- Complete files like a shell.
opt.wildignore = '.git,.hg,*.o,*.a,*.class,*.jar,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc,*.pyo,**/cache/*,**/logs/*,**/target/*,*.hi,tags,**/dist/*,**/public/**/vendor/**,**/public/vendor/**,**/node_modules/**'
opt.wildignorecase = true

opt.scrolloff = 8 -- Start scrolling 8 lines before/after horizontal scrolling
opt.sidescrolloff = 8

-- set relative number on some actions
opt.number = true
vim.cmd([[
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
        autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END
]])

