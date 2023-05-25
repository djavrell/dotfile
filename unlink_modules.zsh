#! /usr/bin/env zsh

source "./modules.zsh"

function rm_file() {
  echo "rm file $2"
  rm -rf "$2"
}

modules_exec rm_file
