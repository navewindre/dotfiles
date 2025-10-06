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
find ./config/ -maxdepth 1 -exec cp -rf '{}' ~/.config/ \;
find ./icons/ -maxdepth 1 -exec cp -rf '{}' ~/.icons/ \;
find ./themes/ -maxdepth 1 -exec cp -rf '{}' ~/.themes/ \;
find ./home/ -maxdepth 1 -exec cp -rf '{}' ~/ \;
find ./bin/ -maxdepth 1 -exec cp -rf '{}' ~/.local/bin \;
mkdir -p ~/.local/bin/
cp -f ./vimrc ~/.vimrc
cp -f ./nvimrc ~/.nvimrc
cp -f ./zshrc ~/.zshrc

rm ~/.config/nvim/init.vim
ln -s ~/.nvimrc ~/.config/nvim/init.vim

gsettings set org.gnome.desktop.interface gtk-theme 'ayaya'
gsettings set org.gnome.desktop.interface icon-theme 'NineIcons'

pushd $PWD
cd ~/.config/openbox
read -p "do you want (s)mall or (b)ig WM fonts?" answer
if [ "$answer" = "s" ]; then
  echo "small titlebars"
  ~/.config/openbox/fonts-small
else
  echo "big titlebars"
  ~/.config/openbox/fonts-big
fi
popd
