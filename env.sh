export PATH="$PATH:$HOME/bin"

export EDITOR="/usr/local/bin/vim"
export DOTFILE="~/.bashrc.d"

# Work
export PROJECT="$HOME/Documents/project"

# nvim
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# tmuxinator
source ~/.bashrc.d/tmuxinator/tmuxinator.zsh

# emscripten sdk
source ~/.bashrc.d/emsdk_set_env.sh

# JAVA
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home"
export ANDROID_HOME="~/Library/Android/sdk"

# SCALA
export SCALA_HOME="/usr/local/share/scala-2.12.6"
export PATH="$PATH:$SCALA_HOME/bin"

# Rust
source $HOME/.cargo/env
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# NVM: node version manger
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ZSH config
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# FZF fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --ansi --type f --hidden --follow --ignore-file ~/.bashrc.d/fdignore"
export FZF_COMPLETION_TRIGGER='%'

# SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Nix
source ~/.nix-profile/etc/profile.d/nix.sh
export PATH="$PATH:~/.nix-profile/bin"
# End Nix

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
