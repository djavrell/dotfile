export LC_ALL=fr_FR.UTF-8
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'

export HISTFILE=~/.zsh_history
export HISTSIZE=1024
export SAVEHIST=1024

# ZSH config
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# GPG
export GPG_TTY=$(tty)

# SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"

# FNM Node version manager
export FNM_DIR="$XDG_DATA_HOME/fnm"
export FNM_LOGLEVEL=quiet

# SCALA
# export SCALA_HOME="/usr/local/share/scala-2.12.6"
# path=( "$SCALA_HOME/bin" $path)
path=( "/Users/kpr/Library/Application Support/Coursier/bin" $path )

# Go
export GOPATH="$HOME/go"
path=( "$GOPATH/bin" $path )

# PostgresSQL
path=( "/opt/homebrew/opt/postgresql@12/bin" $path )

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
path=( "$HOME/.rvm/bin" $path )
load "$HOME/.rvm/scripts/rvm"