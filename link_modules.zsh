#! /usr/bin/env zsh

source "./modules.zsh"

function link_file() {
  echo "link $1 -> $2"
  link "$1" "$2"
}

modules_exec link_file
