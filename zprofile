#! /usr/bin/env zsh

autoload -Uz colors && colors
autoload -Uz compinit

zmodload -i zsh/complist

source "./env.zsh"

# prevent the global variable PATH to have duplicate
typeset -U path
path=(
  "$XDG_BIN_HOME"
  "$DOTFILE/bin"
  "$HOME/bin"
  $path
)

autoload -Uz "$DOTFILE/function.d/load_func"
