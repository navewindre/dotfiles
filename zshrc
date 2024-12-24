export PATH=$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools-bin

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

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
)

source $ZSH/oh-my-zsh.sh

git_prompt() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    if [ -z "$branch" ]; then
      branch=$(git rev-parse --short HEAD 2>/dev/null)
      if [[ ! -z "$branch" ]]; then
        echo "@${branch} (detached)"
      fi
    else
      if [[ "$branch" == "main" ]]; then
        echo ''
      else
        echo "%F{#FFFFFF}@%b%F{#505050}${branch}%F{#FFFFFF}"
      fi
    fi
  fi
}

setopt PROMPT_SUBST

export PS1=$'%m :: %2~$(git_prompt) %B»%b '
# User configuration

autoload -Uz compinit && compinit
alias vim=nvim
alias vi=nvim
alias mpa="mpv --no-video"

alias l='ls'
alias ll='ls -lahG'
alias lg='lazygit'

alias musik='musikcube'

export ANDROID_HOME=/media/data/android-projects

export MANPATH="/usr/local/man:$MANPATH"

export EDITOR='nvim'
export ARCHFLAGS="-arch x86_64"

OLLAMA_HOME="/media/dev/ollama"
OLLAMA_MODELS="/media/dev/ollama/models"
export OLLAMA_HOME
export OLLAMA_MODELS

EMSDK_QUIET=1 source $HOME/code/emsdk/emsdk_env.sh

alias pkg='sudo slpkg --repository="*"'
alias sbopkg='sudo slpkg --repository="sbo"'
alias slpkg="sudo slpkg"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/aurelia/google-cloud-sdk/path.zsh.inc' ]; then . '/home/aurelia/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/home/aurelia/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aurelia/google-cloud-sdk/completion.zsh.inc'; fi

zstyle ':completion:*' menu select
fpath+=~/.zfunc

source ~/.lscolors
source ~/.profile

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
