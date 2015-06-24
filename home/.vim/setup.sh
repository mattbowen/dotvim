#!/bin/bash
WORKINGDIR=$PWD
mkdir -p ~/.vim/bundle
if [[ ! -d ~/.vim/bundle/vundle ]]; then
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi
vim +PluginInstall +qall
~/.vim/bundle/YouCompleteMe/install.sh --clang
type npm >/dev/null 2>&1 || (cd ~/.vim/bundle/tern_for_vim && npm install)
cd $WORKINGDIR

