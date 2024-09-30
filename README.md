# dotfiles

## notes
you need neovim 0.10.1 at least

best to compile nvim from source

1. uninstall nvim
```
sudo apt remove nvim neovim
```
2. make sure nvim isnt installed somewhere else
```
where nvim
```
3. if it is, delete it
```
sudo rm {vim location here}
```
4. build and install neovim from source:
```
git clone https://github.com/neovim/neovim.git
cd neovim
sudo make install
```

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
ln -s ~/.vimrc ~/.config/nvim/init.vim
```
6. open vim
7. run :PlugInstall
8. install dependencies
```
sudo apt install fd-find ripgrep
```
9. enjoy

## for completions

1. install tabby
https://tabby.tabbyml.com/docs/quick-start/installation/linux/
2. register an account
https://tabby.tabbyml.com/docs/quick-start/register-account/
3. copy your api key into ~/.tabby_client/agent/config.toml
4. enjoy

## for tabby autorunner

1. put contents of tabby-runner/ into the same folder as tabby
2. edit run-client.sh to use models of your liking. consult https://tabby.tabbyml.com/docs/models
3. install node modules
4. run the script with ./run.sh. it will open tabby automatically when vim is opened.

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
