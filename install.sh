#!/usr/bin/env bash

# link dotfiles

echo "linking configs"
rm -v ~/.vimrc
ln -v vimrc ~/.vimrc
rm -v ~/.gitconfig
ln -v gitconfig ~/.gitconfig
rm -v ~/.bashrc
ln -v bashrc ~/.bashrc
rm -v ~/.bin
ln -s bin ~/.bin
rm -rv ~/.vim
ln -s $(pwd)/vim ~/.vim
rm -v ~/.tmux.conf
rm -v ~/.ssh/config
if [[ $(hostname) == CSI* ]] ;
then
    echo "running on CSI host"
    ln -v ssh/csi_config ~/.ssh/config
    ln -v csi_tmux.conf ~/.tmux.conf
else
    ln -v ssh/bastion_config ~/.ssh/config
    ln -v bastion_tmux.conf ~/.tmux.conf
fi



