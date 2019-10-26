#! /bin/sh

# pouvoir trouver la distro linux en plus au cas où
SYSTEM=`uname -s | tr '[:upper:]' '[:lower:]'`

source "./$SYSTEM/variables.sh"
PACKAGE_SOURCE="./$SYSTEM/packages.txt"

# pre install hook
pre_install
echo "will use: $INSTALLER as installer"

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

if [ "${SHELL##*/}" != "zsh" ]; then
  echo "Zsh install"
  $INSTALLER zsh zsh-completions
  chsh -s "/bin/zsh"
  echo "You need to logout and relaunch this script in order to properly activate zsh"
  exit 1
fi

# Install packages
echo "Instal packages from $PACKAGE_SOURCE"
install_packages $PACKAGE_SOURCE
