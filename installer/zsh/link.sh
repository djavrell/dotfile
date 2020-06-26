#! /bin/sh

function link() {
  echo "link zsh configuration file"
  echo $PWD
  # stow --ignore='^(?<!dot-)[\w\.]+' --dotfiles .
}

