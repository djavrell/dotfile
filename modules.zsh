#! /usr/bin/env zsh

source "./env.zsh"

typeset -U mods=(
  "core"
  "zsh"
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
  "wezterm"
)

autoload -Uz "$DOTFILE/function.d/load_actions"

function modules_exec() {
  typeset -U linkHash

  load_actions "link" "$mods"

  for action in "${reply[@]}"; do
    ${(z)action}
    linkHash+=($reply)
  done

  for source dest in ${(kv)linkHash}; do
    $1 $source $dest
  done
}
