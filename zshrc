export PATH=$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="evan"
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-colorls
)

source $ZSH/oh-my-zsh.sh

# User configuration

autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
alias vim=nvim
alias vi=nvim
alias mpa="mpv --no-video"

alias l='ls'
alias lg='lazygit'

export ANDROID_HOME=/media/aurelia/data/android-projects

export MANPATH="/usr/local/man:$MANPATH"

export EDITOR='nvim'
export ARCHFLAGS="-arch x86_64"

OLLAMA_HOME="/media/aurelia/dev/ollama"
OLLAMA_MODELS="/media/aurelia/dev/ollama/models"
export OLLAMA_HOME
export OLLAMA_MODELS

EMSDK_QUIET=1 source $HOME/code/emsdk/emsdk_env.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/aurelia/google-cloud-sdk/path.zsh.inc' ]; then . '/home/aurelia/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/home/aurelia/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aurelia/google-cloud-sdk/completion.zsh.inc'; fi

zstyle ':completion:*' menu select
fpath+=~/.zfunc
