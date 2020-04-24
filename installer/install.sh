#! /bin/sh

cd $(dirname $0)

# TODO: find the current linux distribution too
SYSTEM=`uname -s | tr '[:upper:]' '[:lower:]'`

# load all needed variables for the current os in use
#
# files:
#   - variables_<os>.sh
#   - packages_<os>.sh
#   - symlinks_<os>.sh
#
# variables -> this file must have thoses variables defined
#   - INSTALLER_TOOLS (aka: pacman, brew, ...)
source "./$SYSTEM/variables.sh"

# install the package manager if needed
PM_install
echo "will use: $INSTALLER as installer"
echo "update of the os"
global_update

function install_zsh() {
  if [ "${SHELL##*/}" != "zsh" ]; then
    echo "Zsh install"
    $INSTALLER zsh zsh-completions
    chsh -s "/bin/zsh"
  fi

  # install + link zsh configuration
  cd ../zsh
  echo "init zsh submodule"
  git submodules init
  cd ..
  echo "link zsh configuration file"
  stow --ignore='^(?<!dot-)[\w\.]+' --dotfiles zsh
  cd $(dirname $0)

  echo "You need to logout and relaunch this script in order to properly activate zsh"
}


install_zsh
install_packages

# Stowing
stow --ignore='^(?<!dot-)[\w\.]+' --dotfiles zsh tmux git
stow --dotfiles nvim pgcli wuzz vifm
