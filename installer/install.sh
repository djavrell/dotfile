#! /bin/sh

cd $(dirname $0)

# TODO: find the current linux distribution too
export SYSTEM=`uname -s | tr '[:upper:]' '[:lower:]'`

source "./global/install.sh"
global

function install_zsh() {
  if [ "${SHELL##*/}" != "zsh" ]; then
    echo "Zsh install"
    $INSTALLER zsh zsh-completions
    chsh -s "/bin/zsh"
  fi

  # install + link zsh configuration
  cd ..
  echo "init zsh submodule"
  git submodule update --init --recursive
  echo "link zsh configuration file"
  stow --ignore='^(?<!dot-)[\w\.]+' --dotfiles zsh
  cd $(dirname $0)

  echo "You need to logout and relaunch this script in order to properly activate zsh"
}

function install_vim() {
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  nvim +PlugInstall
}

# install the package manager if needed
install_zsh
install_packages
install_vim

# Stowing
## this regex ignore all files that are not starting with `dot-`
stow --ignore='^(?<!dot-)[\w\.]+' --dotfiles tmux git
stow --dotfiles nvim pgcli wuzz vifm
