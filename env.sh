export PATH="$PATH:$HOME/bin"

# NVM: node version manger
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# nvim
export XDG_CONFIG_HOME="$HOME/.config/nvim"
export XDG_DATA_HOME="$HOME/.local/share/nvim"

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

# ZSH config
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# FZF fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --ignore-file ~/.bashrc.d/fdignore"
export FZF_COMPLETION_TRIGGER='%'

# SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"
