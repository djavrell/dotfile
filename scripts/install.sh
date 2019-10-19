#! /bin/sh

SYSTEM=`uname -s | tr '[:upper:]' '[:lower:]'`

case $SYSTEM in
  "darwin")
    INSTALLER="brew"
    ;;
  "linux")
    INSTALLER="pacman"
    ;;
esac

echo "will use: $INSTALLER as installer"

if [ "${SHELL##*/}" != "zsh" ]; then
  echo "Zsh install"
  sudo pacman -S zsh zsh-completions
  sudo chsh -s "/bin/zsh"
  echo "you need to logout and relaunch this script in order to properly activate zsh"
  exit 1
fi
