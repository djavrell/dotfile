#! /usr/bin/env zsh

source "./env.zsh"

autoload -Uz "$DOTFILE/function.d/load_actions"
autoload -Uz "$DOTFILE/function.d/link"

typeset -U linkHash

load_actions "link" "$mods"

for action in "${reply[@]}"; do
  ${(z)action}
  linkHash+=($reply)
done

for source dest in ${(kv)linkHash}; do
  link "$source" "$dest"
done
