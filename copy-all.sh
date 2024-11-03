#!/bin/bash

echo "WARNING: this will overwrite the config"
read -p "are you sure? (y/n): " answer
if [ "$answer" != "y" ]; then
    echo "Aborting."
    exit 1
fi

cp -r ./config/* ~/.config/
cp -r ./icons/* ~/.icons/
cp -r ./themes/* ~/.themes/
cp ./vimrc ~/.vimrc
cp ./zshrc ~/.zshrc
