set nocompatible              " required
filetype off                  " required

filetype plugin indent on    " required

set cursorline
set termencoding=utf-8
set fileencodings=utf-8,default

set autoread  " watch for file changes

" no file auto-backup since we use Git
set nowb
set nobackup
set noswapfile

" tab-related, unsure
set smarttab
set textwidth=8
" use :retab to change all tabs to match these settings
set expandtab       " insert tabs instead of spaces:
set tabstop=4       " number of spaces:
set shiftwidth=4    " number of spaces for indentation:
set shiftround      " always round indents to multiple of shiftwidth
set autoindent
set smartindent
set copyindent      " use existing indents for new indents
set preserveindent  " save as much indent structure as possible

" delimit word change
set cpoptions+=$

" http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
set nowrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
" related to above?
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
" Change signs for end of line, trailing whitespaces and tabs
set listchars=tab:▸\ ,eol:¬,trail:\·

" code folding, unfinished
set foldmethod=indent
" set nofoldenable
set foldlevel=99

" remove empty lines at end of file
" %s/\($\n\s*\)\+\%$//e
" Removing trailing whitespaces in Vim can be done pretty easy:
" autocmd BufWritePre * :%s/\s\+$//e

" highlight all matches of search pattern,
" search all occurrences of current word with '*'
set hlsearch


" PHP parser check (CTRL-L)
" autocmd FileType php noremap <C-L> <Esc>:w!<CR>:!php -l %<CR>
" run file with PHP CLI (CTRL-M)
" autocmd FileType php noremap <C-M> <Esc>:w!<CR>:!php %<CR>

" Easier window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

let mapleader=","
let maplocalleader=","

nmap <CR> :

nmap <C-W>t <Esc>:tabnew<CR>

" Press i to enter insert mode, and ii to exit
" (http://vim.wikia.com/wiki/Avoid_the_escape_key)
:imap jj <Esc>

" open new split panes to right, bottom
set splitright
set splitbelow

if has("gui_running")
  set columns=195
  set guioptions-=T

  " wtf?
  set mouse=a
  map <S-Insert> <MiddleMouse>
  nmap gx <Plug>NetrwBrowseX

  if has('mac') || has('macunix')
    color solarized
    set guifont=Inconsolata:h12
    set lines=80
    set transparency=3
  else
    color underwater-mod
    set guifont=DejaVu\ Sans\ Mono\ 8
    set lines=72
  end
else
  set t_Co=256
  set background=dark
  color desert
  " disable Background Color Erase (BCE) to fix Vim background on 256-color Tmux
  " ref: http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif


" Per-directory .vimrc files
set exrc
set secure

" NerdTree-like filelist style for netrw
let g:netrw_liststyle=3

au BufRead,BufNewFile Gemfile set filetype=ruby
au BufRead,BufNewFile *.ru setfiletype ruby
au BufRead,BufNewFile *.jade set filetype=slim
au BufRead,BufNewFile *.pug set filetype=slim
au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile *.tag set filetype=javascript

" enable Vundles/Plugins explicity where supported
" source ~/dotfiles/.vimrc_plug
"

"show status bar on single window mode
set laststatus=2

set relativenumber
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Enable folding with the spacebar
nnoremap <space> za

"automatic closing
inoremap (<CR> (<CR>)<C-c>O
inoremap (; (<CR>);<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {<CR> {<CR>}<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap [<CR> [<CR>]<C-c>O

syntax on
