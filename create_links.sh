#!/bin/bash

SRC_PATH=$(dirname `pwd`/$0)

ln -sfv $SRC_PATH/.bashrc $HOME/.bashrc
ln -sfv $SRC_PATH/.tmux.conf $HOME/.tmux.conf
ln -sfv $SRC_PATH/.vim $HOME/.vim
ln -sfv $SRC_PATH/.vimrc $HOME/.vimrc
