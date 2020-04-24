#!/bin/sh

INSTALLER="yay"
INSTAL_ALL="yay -S"
PACKAGES="./packages.txt"

function PM_install() {
  which $INSTALLER > /dev/null 2>&1
  if [ $? -eq 1 ]; then
    echo "Installing $INSTALLER"
    sudo pacman -S $INSTALLER
  fi
}

function global_update() {
  $INSTALLER -Syu
}

# $1: file containing all package to install
function install_packages() {
  echo "Installing packages"
  $INSTAL_ALL $(cat "$PACKAGES")
}
