typeset -ga loading

export LC_ALL=fr_FR.UTF-8
export EDITOR="nvim"
export VISUAL="nvim"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'

export HISTFILE=~/.zsh_history
export HISTSIZE=1024
export SAVEHIST=1024

path=( "$HOME/bin" $path )
path=( "$HOME/.local/bin" $path )
path=( "$DOTFILE/bin" $path )

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# tmuxinator
path=( "$SHEL_ROOT/tmuxinator.zsh" $path )

# SCALA
export SCALA_HOME="/usr/local/share/scala-2.12.6"
path=( "$SCALA_HOME/bin" $path)

# Rust
. "$HOME/.cargo/env"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Go
export GOPATH="$HOME/go"
path=( "$GOPATH/bin" $path )

# ZSH config
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# FZF fuzzy finder
loading+="$SHELL_ROOT/fzf.zsh"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --ignore-file $SHELL_ROOT/fdignore"
export FZF_COMPLETION_TRIGGER='%'

# SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
path=( "$HOME/.rvm/bin" $path )
loading+="$HOME/.rvm/scripts/rvm"

# Haskell
loading+="$HOME/.ghcup/env"

get_export() {
  echo $loading
}
