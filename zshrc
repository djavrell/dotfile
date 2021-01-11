# zmodload zsh/zprof # top of your .zshrc file

autoload -Uz colors && colors
autoload -Uz compinit

zmodload -i zsh/complist

function load_func() {
  for func in $(ls "$1"); do
    autoload -Uz $func
  done
}
autoload -Uz load_func
#
# prevent the global variable PATH to have duplicate
typeset -U path

DOTFOLDER=".bashrc.d"
export DOTFILE="$HOME/$DOTFOLDER"
export SUB_MODULES="$DOTFILE/submodules"

SYSTEM_FILE=`uname -s | tr '[:upper:]' '[:lower:]'`
export SYSFILE="$DOTFILE/$SYSTEM_FILE"

# load all core function
fpath=( "$DOTFILE/function.d" $fpath )
load_func "$DOTFILE/function.d"

# export all environement variables
load "$DOTFILE/zsh/init.zsh"
load "$DOTFILE/git/init.zsh"

load "$SYSFILE/init.zsh" # load conf for the current system (linux/darwin/...)
load "$DOTFILE/local.sh"

# uncomment to know what take to much time at the load and init time
# DOn't forget to uncomment the 'import' at the top of the file
# zprof
