let mapleader=";"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'vim-scripts/taglist.vim'
Plugin 'pthrasher/conqueterm-vim'
Plugin 'SearchComplete'
Plugin 'scratch.vim'

call vundle#end()

filetype plugin indent on
syntax on

runtime! ftplugin/man.vim

set autoindent
set tabstop=4
set shiftwidth=4
set relativenumber
set wildmenu

set splitbelow
set splitright

colorscheme delek

let NERDTreeQuitOnOpen = 1
let NERDTreeBookmarkFile="$HOME/.vim/NERDTreeBookmarks"
let ConqueTerm_CloseOnEnd = 1
hi Directory ctermfg=cyan

" Clang complete options
let g:clang_auto_select=1
let g:clang_close_preview=1
let g:clang_periodic_quickfix=1

let g:yankring_history_dir = '$HOME/.vim'


nnoremap <Leader>t :buffers<CR>:buffer<Space>
inoremap jk <ESC>l
vnoremap jk <ESC>
"Mappings for pane movement
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
inoremap <C-j> <Esc><C-w><C-j>
inoremap <C-k> <Esc><C-w><C-k>
inoremap <C-h> <Esc><C-w><C-h>
inoremap <C-l> <Esc><C-w><C-l>
" Mappings for quickfix
nnoremap <Leader>ne :<C-u>cnext<CR>
nnoremap <Leader>pr :<C-u>cprev<CR>
nnoremap <Leader>make :<C-u>w \| make<CR>

nnoremap <Leader>ev :split ~/.vimrc<CR>
nnoremap <Leader>et :split ~/.tmux.conf<CR>
nnoremap <Leader>eb :split ~/.bashrc<CR>

nnoremap <Leader><F8> :NERDTreeToggle<CR>
nnoremap <Leader>p :YRShow<CR>
nnoremap <Leader>x :Sscratch<CR>
nnoremap <Leader>r :%s/<C-r><C-w>/

nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gc :Gcommit<CR>

nnoremap <Leader>m :w \| make<cr>
nnoremap <Leader>b :ConqueTermVSplit bash<cr>
nnoremap <Leader>q :call QuickFixToggle()<cr>
nnoremap <Leader>ne :cnext<cr>
nnoremap <Leader>pr :cprevious<cr>

nnoremap <Leader>c :r!xsel<cr>

cnoreab make w \| make

au BufLeave ~/.vimrc :source ~/.vimrc

augroup *.cabal
	au BufNewFile,BufRead *.cabal set expandtab
	au BufNewFile,BufRead *.cabal set tabstop=4
	au BufNewFile,BufRead *.cabal set shiftwidth=4
augroup END

augroup *.hs
	au BufNewFile,BufRead *.hs set expandtab
	au BufNewFile,BufRead *.hs set tabstop=4
	au BufNewFile,BufRead *.hs set shiftwidth=4
	au BufNewFile,BufRead *.hs set colorcolumn=80
augroup END

augroup *.py
	au BufNewFile,BufRead *.py set noexpandtab
	au BufNewFile,BufRead *.py set tabstop=8
	au BufNewFile,BufRead *.py set shiftwidth=8
	au FileType python set omnifunc=pythoncomplete#Complete
	au FileType python let g:SuperTabDefaultCompletionType = "context"
	au FileType python set completeopt=menuone,longest,preview
augroup END

augroup conque
	au FileType conque_term set colorcolumn=0
	au FileType conque_term :autocmd! BufEnter <buffer> :startinsert
	au FileType conque_term inoremap <buffer> <Leader><C-j> <ESC><C-w><C-j>
	au FileType conque_term inoremap <buffer> <Leader><C-k> <ESC><C-w><C-k>
	au FileType conque_term inoremap <buffer> <Leader><C-h> <ESC><C-w><C-h>
	au FileType conque_term inoremap <buffer> <Leader><C-l> <ESC><C-w><C-l>
augroup END

augroup man
	au FileType help nnoremap <buffer> q :<C-u>q<CR>
	au FileType man nnoremap <buffer> q :<C-u>q<CR>
augroup END

function! s:ExecuteInShell(command)
	let command = join(map(split(a:command), 'expand(v:val)'))
	let winnr = bufwinnr('^' . command . '$')
	silent! execute  winnr < 0 ? 'botright new ' . shellescape(command) : winnr . 'wincmd w'
	setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
	silent! execute 'silent %!'. command
	silent! execute 'resize ' . line('$')
	silent! redraw
	silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
	silent! execute 'nnoremap <buffer> q :q<CR>'
	silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
ca shell Shell
