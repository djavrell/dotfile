#!/bin/sh

INSTALLER="yay -S"
INSTAL_ALL="yay -S"

function pre_install() {
  which yay
  if [ $? -eq 1 ]; then
    echo "Installing yay"
    git clone https://aur.archlinux.org/yay.git yay
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
  fi
}

# $1: file containing all package to install
function install_packages() {
  echo "Installing ...."
  $INSTAL_ALL < $1
}
