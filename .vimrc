let mapleader=";"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'vim-scripts/YankRing.vim'
Bundle 'vim-scripts/taglist.vim'
Bundle 'pthrasher/conqueterm-vim'

filetype plugin indent on

runtime! ftplugin/man.vim

set autoindent
set tabstop=4
set shiftwidth=4
set relativenumber

let NERDTreeQuitOnOpen = 1
let NERDTreeBookmarkFile="$HOME/.vim/NERDTreeBookmarks"
hi Directory ctermfg=3

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
" Mappings for quickfix
nnoremap <Leader>ne :<C-u>cnext<CR>
nnoremap <Leader>pr :<C-u>cprev<CR>
nnoremap <Leader>make :<C-u>w \| make<CR>

nnoremap <Leader>ev :split ~/.vimrc<CR>
nnoremap <Leader>et :split ~/.tmux.conf<CR>
nnoremap <Leader>eb :split ~/.bashrc<CR>

nnoremap <Leader><F8> :NERDTreeToggle<CR>
nnoremap <Leader>p :YRShow<CR>

au BufLeave ~/.vimrc :source ~/.vimrc
au BufLeave ~/.tumx.conf :source ~/.tmux.conf
au BufLeave ~/.bashrc :source ~/.bashrc

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
	au FileType python set omnifunc=pythoncomplete#Complete
	au FileType python let g:SuperTabDefaultCompletionType = "context"
	au FileType python set completeopt=menuone,longest,preview
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
