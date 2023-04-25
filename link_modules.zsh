#! /usr/bin/env zsh

source "./zprofile"

local oldFPath=$fpath
typeset -U actions

load_func "core"

loads=("zsh" "git" "nvim" "tmux" "tmuxinator")
load_actions "link" "$loads"

for action in "${actions[@]}"; do
  echo "$action"
  ${(z)action}
done

fpath=($oldFPath)
