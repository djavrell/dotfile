#!/bin/sh

INSTALLER="sudo pacman -S"
INSTAL_ALL="sudo pacman -Sa --needed -"

function pre_install() {
}

# $1: file containing all package to install
function install_all() {
  echo "Installing ...."
  $INSTAL_ALL < $1
}
