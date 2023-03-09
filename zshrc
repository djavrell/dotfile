# zmodload zsh/zprof # top of your .zshrc file

autoload -Uz colors && colors
autoload -Uz compinit

zmodload -i zsh/complist

function load_func() {
  local new_path="$DOTFILE/$1/function.d"

  fpath=( "$new_path" $fpath )

  for func in $(ls "$new_path"); do
    echo "$func"
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
load_module "core"

# load modules (env var, alias, ...)
load_module "zsh"
load_func "zsh"
load_module "git"
load_module "tmux"
load_module "navi"
load_module "nvim"

# uncomment to know what take to much time at the load and init time
# DOn't forget to uncomment the 'import' at the top of the file
# zprof
