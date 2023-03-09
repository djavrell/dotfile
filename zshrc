# zmodload zsh/zprof # top of your .zshrc file

autoload -Uz colors && colors
autoload -Uz compinit

zmodload -i zsh/complist

function load_func() {
  local new_path="$DOTFILE/$1/function.d"

  fpath=( "$new_path" $fpath )

  for func in $(ls "$new_path"); do
    autoload -Uz $func
  done
}
autoload -Uz load_func

# prevent the global variable PATH to have duplicate
typeset -U path

DOTFOLDER=".bashrc.d"
export DOTFILE="$HOME/$DOTFOLDER"
export SUB_MODULES="$DOTFILE/submodules"

# load all core function
load_func "core"
load_func "zsh"

# load modules (env var, alias, ...)
module "core"
module "zsh"
module "git"
module "tmux"
module "navi"
module "nvim"

# uncomment to know what take to much time at the load and init time
# DOn't forget to uncomment the 'import' at the top of the file
# zprof
