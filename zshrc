#! /usr/bin/env zsh
# zmodload zsh/zprof

autoload -Uz colors && colors
autoload -Uz compinit

zmodload -i zsh/complist

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_BIN_HOME="$HOME/.local/bin"

export DOTFILE="$HOME/.bashrc.d"
export SUB_MODULES="$DOTFILE/submodules"

export SYSTEM_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
export SYSTEM_HARDWARE=$(uname -m | tr '[:upper:]' '[:lower:]')
export SYSFILE="$DOTFILE/$SYSTEM_NAME"

# prevent the global variable PATH to have duplicate
typeset -U path
path=(
  "$XDG_BIN_HOME"
  "$DOTFILE/bin"
  "$HOME/bin"
  $path
)

autoload -Uz "$DOTFILE/function.d/load_func"

# this function will be called in the ZSH module (zvm after init)
# due to the vim mode plugin.
function zsh_after_init() {
  module "git"
  module "starship"
  module "fzf"
  module "tmux"
  module "tmuxinator"
  module "navi"
  module "nvim"
  module "kitty"
  module "rust"
  module "python"
}

# load all core function
load_func "core"

# loadMod "$preMod"
module "core"
module "zsh"

load "$SYSFILE/init.zsh" # load conf for the current system (linux/darwin/...)
load "$DOTFILE/local.zsh"
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# uncomment to know what take to much time at the load and init time
# Don't forget to uncomment the 'import' at the top of the file
# zprof
