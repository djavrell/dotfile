#!/bin/sh

INSTALLER="yay -S"
INSTAL_ALL="yay -S"
PACKAGES="packages.txt"

function pre_install() {
  which yay > /dev/null 2>&1
  if [ $? -eq 1 ]; then
    echo "Installing yay"
    sudo pacman -S yay
  fi
}

# $1: file containing all package to install
function install_packages() {
  echo "Installing ...."
  $INSTAL_ALL $(cat $PACKAGES)
}
