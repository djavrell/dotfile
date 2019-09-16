export LC_ALL=fr_FR.UTF-8
export EDITOR="/usr/local/bin/nvim"

fpath=( "$HOME/bin" $fpath )


# nvim
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# tmuxinator
load "$DOTFILE/tmuxinator/tmuxinator.zsh"

# JAVA
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home"

# SCALA
export SCALA_HOME="/usr/local/share/scala-2.12.6"
fpath=( "$SCALA_HOME/bin" $fpath)

# Rust
load "$HOME/.cargo/env"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Go
export GOPATH="$HOME/go"
fpath=( "$GOPATH/bin" $fpath )

# NVM: node version manger
export NVM_DIR="$HOME/.nvm"
load "$NVM_DIR/nvm.sh"
load "$NVM_DIR/bash_completion"

# ZSH config
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# FZF fuzzy finder
load "~/.fzf.zsh"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --ignore-file ~/.bashrc.d/fdignore"
export FZF_COMPLETION_TRIGGER='%'

# SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Nix
load "~/.nix-profile/etc/profile.d/nix.sh"
fpath=( "$HOME/.nix-profile/bin" $fpath )
# End Nix

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
fpath=( "$HOME/.rvm/bin" $fpath )
load "~/.rvm/scripts/rvm"
