# dotfiles

## install

1. install zsh (sudo apt install zsh)
2. install oh-my-zsh
```
sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
```
3. put config in ~/.config/
4. put vimrc in ~/.vimrc
5. run:
```
ln -s ~/.config/nvim/init.vim ~/.vimrc
```
6. open vim
7. run :PlugInstall
8. enjoy
