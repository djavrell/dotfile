#! /bin/sh

# pouvoir trouver la distro linux en plus au cas où
SYSTEM=`uname -s | tr '[:upper:]' '[:lower:]'`

# charger les variable en fonction d'un fichier nommé trouvable grace à uname
#
# files:
#   - variables_<os>.sh
#   - packages_<os>.sh
#   - symlinks_<os>.sh
#
# variables -> ce fichier vont definir les variables suivantes:
#   - INSTALLER_TOOLS (aka: pacman, brew, ...)
#   -


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
