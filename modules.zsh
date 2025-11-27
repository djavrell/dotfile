#! /usr/bin/env zsh

# source "./env.zsh"

typeset -U mods=(
  "core"
  "zsh"
  "git"
  "starship"
  "fzf"
  "navi"
  "nvim"
  # "rust"
  # "python"
  "wezterm"
)

autoload -Uz "$DOTFILE/function.d/load_actions"

function modules_exec() {
  # Use a unique associative array to collect link source/destination pairs
  typeset -U linkHash

  # Populate $reply with a list of "link" actions for all modules in $mods
  load_actions "link" "$mods"

  # Execute each action command stored in $reply; each action should set $reply to a source/dest pair
  for action in "${reply[@]}"; do
    ${(z)action}
    linkHash+=($reply)
  done

  # Iterate over the collected source/dest pairs and call the provided function ($1) with them
  for source dest in ${(kv)linkHash}; do
    $1 $source $dest
  done
}
