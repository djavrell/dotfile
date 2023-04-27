#! /usr/bin/env zsh

source "./env.zsh"

autoload -Uz "$DOTFILE/function.d/load_actions"
autoload -Uz "$DOTFILE/function.d/link"

local oldFPath=$fpath
typeset -U actions
typeset -U linkHash

load_actions "link" "$mods"
actions=($reply)

for action in "${actions[@]}"; do
  ${(z)action}
  linkHash=( $linkHash $reply )
done

for source dest in ${(kv)linkHash}; do
  link "$source" "$dest"
done

fpath=($oldFPath)
