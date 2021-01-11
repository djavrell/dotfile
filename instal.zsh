#! /bin/zsh

SYSTEM=`uname -s | tr '[:upper:]' '[:lower:]'`
supported_system=(
  darwin
  linux
)

# if $1 is not in the array, return 0
function is_system_supported {
  return ${supported_system[(Ie)$1]}
}

function get_installer {
  case "$SYSTEM" in
    "darwin")
      echo "brew install"
      ;;
    "linux")
      echo "yay"
      ;;
    *)
      echo "$SYSTEM not supported"
      exit -1
      ;;
  esac
}

function install_command {
  if ((${+commands[$1]} == 0)); then
    echo "install $1"
  else
    echo "$1 is installed"
  fi
}

# check if all deps are installed before installing
# $1: primary cmd to install
# $2: an array with all deps
function install_with_deps {
  if [[ "$#" -ne "3" ]]; then
    echo "usage: install_with_deps \"cmd\" (dep1 dep1 ...) "
    exit -1
  fi

  cmd=$1
  shift

  for dep in $@;
  do
    install_command "$dep"
  done
  install_command "$cmd"
  exit 0
}

is_system_supported "$SYSTEM"
if [[ "$?" -eq "0" ]]; then
  echo "$SYSTEM is not supported yet"
  exit -1
fi

# install_with_deps "git" "vim" "rustup"
get_installer
