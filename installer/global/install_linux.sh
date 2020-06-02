#! /bin/sh

export PM="yay"
export INSTALLER="yay -S"

PACKAGES="./global/packages_linux.txt"

function install_PM() {
  which $PM > /dev/null 2>&1
  if [ $? -eq 1 ]; then
    echo "Installing $PM"
    sudo pacman -S $PM
  fi
}

function global_update() {
  echo "update system"
  $INSTALLER -Syu
}

function install_packages() {
  echo "install all package"
  $INSTALL $(cat $PACKAGES)
}
