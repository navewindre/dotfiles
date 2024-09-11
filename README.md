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

## for completions

1. install tabby
https://tabby.tabbyml.com/docs/quick-start/installation/linux/
2. register an account
https://tabby.tabbyml.com/docs/quick-start/register-account/
3. copy your api key into ~/.tabby_client/agent/config.toml
4. enjoy

## for local llm (avante)

1. install ollama
2. run ollama (probably wanna add this to startup
```
ollama serve
```
3. install the model
```
ollama pull llama3.1:8b-instruct-q5_K_M
```
4. enjoy
