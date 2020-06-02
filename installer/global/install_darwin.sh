#! /bin/sh

export PM="brew"
export INSTALLER="brew install"

PACKAGES="./global/packages_darwin.txt"

function install_PM() {
  which "$PM" > /dev/null >&1
  if [ $? -eq 1 ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

function global_update() {
  $PM update
  $PM upgrade
  $PM tap Homebrew/bundle
}

function install_packages() {
  $PM bundle --file="./global/packages_darwin.txt"
}
