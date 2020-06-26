#! /bin/sh

source "./global/install_$SYSTEM.sh"

function global() {
  install_PM
  global_update
  install_packages
}

global
