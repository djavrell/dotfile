#! /bin/sh
set -e

function install_shell() {
  if [[ "$SHELL##*/" != "zsh" ]]; then
    echo "installing Zsh"
    $INSTALLER zsh zsh-completions
    chsh -s "/bin/zsh"
  fi
}

function install() {}
