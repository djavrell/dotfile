# XDG spec
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_BIN_HOME="$HOME/.local/bin"

export SYSTEM_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
export SYSTEM_HARDWARE=$(uname -m | tr '[:upper:]' '[:lower:]')
export SYSFILE="$DOTFILE/$SYSTEM_FILE"

export DOTFILE="$HOME/.bashrc.d"
export SUB_MODULES="$DOTFILE/submodules"

typeset -U preMod=(
  "core"
  "zsh"
)

typeset -U postMod=(
  "git"
  "starship"
  "fzf"
  "tmux"
  "tmuxinator"
  "navi"
  "nvim"
  "kitty"
  "rust"
  "python"
)

typeset -U mods=(
  $preMod
  $postMod
)
