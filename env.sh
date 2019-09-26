typeset -ga loading

export LC_ALL=fr_FR.UTF-8
export EDITOR="nvim"
export VISUAL="nvim"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'

export HISTFILE=~/.zsh_history         # where to store zsh config
export HISTSIZE=1024                   # big history
export SAVEHIST=1024                   # big history

path=( "$HOME/bin" $path )

# nvim
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# tmuxinator
path=( "$DOTFILE/tmuxinator/tmuxinator.zsh" $path )

# JAVA
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home"

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
loading+="$HOME/.fzf.zsh"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --ignore-file ~/.bashrc.d/fdignore"
export FZF_COMPLETION_TRIGGER='%'

# SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Nix
loading+="$HOME/.nix-profile/etc/profile.d/nix.sh"
path=( "$HOME/.nix-profile/bin" $path )
# End Nix

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
path=( "$HOME/.rvm/bin" $path )
loading+="$HOME/.rvm/scripts/rvm"

get_export() {
  echo $loading
}
