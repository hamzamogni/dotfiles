local opt = vim.opt

opt.guicursor = ""

opt.nu = true
opt.relativenumber = true

opt.autoread = true -- Set to auto read when a file is changed from the outside
opt.undofile = true -- Persistent
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.backup = false  -- don't make backup before overwriting file
opt.swapfile = false

-- INDENTATIONS
opt.expandtab = true -- Expand tabs to spaces
opt.shiftwidth = 4   -- The # of spaces for indenting
opt.softtabstop = 4
opt.tabstop = 4

opt.smartindent = true

opt.colorcolumn = "80"

-- SEARCH
opt.hlsearch = false -- Highlight searches
opt.incsearch = true -- Highlight dynamically as pattern is typed

-- APPEARENCE
opt.wrap = false     -- Do not wrap lines
opt.showmode = false -- Do not show mode (will be taken care of by lightline)

-- EXTRAS
opt.cursorline = true -- Highlight current line

opt.scrolloff = 8     -- Start scrolling 8 lines before/after horizontal scrolling
opt.signcolumn = "yes"

opt.updatetime = 50

opt.termguicolors = true
