#!/bin/bash

echo "WARNING: this will overwrite the config"
read -p "are you sure? (y/n): " answer
if [ "$answer" != "y" ]; then
    echo "Aborting."
    exit 1
fi

mkdir -p ~/.config
mkdir -p ~/.icons
mkdir -p ~/.themes
cp -rf ./config/ ~/.config/
cp -rf ./icons/ ~/.icons/
cp -rf ./themes/ ~/.themes/
mkdir -p ~/.local/bin/
cp -rf ./bin ~/.local/bin/
cp -rf ./home/ ~/
cp -f ./vimrc ~/.vimrc
cp -f ./nvimrc ~/.nvimrc
cp -f ./zshrc ~/.zshrc

rm ~/.config/nvim/init.vim
ln -s ~/.nvimrc ~/.config/nvim/init.vim
