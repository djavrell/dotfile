#! /usr/bin/env zsh

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
