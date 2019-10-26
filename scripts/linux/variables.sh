#!/bin/sh

INSTALLER="sudo pacman -S"
INSTAL_ALL="sudo pacman -Sa --needed -"

function pre_install() {
  echo "pre_install hook (do nothing here)"
}

# $1: file containing all package to install
function install_packages() {
  echo "Installing ...."
  $INSTAL_ALL < $1
}
