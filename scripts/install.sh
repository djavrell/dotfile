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

/bin/sh: q : commande introuvable
  echo "Zsh install"
  sudo pacman -S zsh zsh-completions
fi
