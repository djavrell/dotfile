# zmodload zsh/zprof # top of your .zshrc file

autoload -Uz colors && colors
autoload -Uz compinit

zmodload -i zsh/complist

function load_func() {
  local new_path="$DOTFILE/$1/function.d"

  fpath=( "$new_path" $fpath )
  autoload -Uz $(ls "$new_path")
}
autoload -Uz load_func

# prevent the global variable PATH to have duplicate
typeset -U path

# dotfiles
export DOTFILE="$HOME/.bashrc.d"
export SUB_MODULES="$DOTFILE/submodules"

# XDG spec
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# load all core function
load_func "core"
load_func "zsh"

# load modules (env var, alias, ...)
module "core"
module "zsh"
module "git"
module "starship"
module "tmux"
module "tmuxinator"
module "navi"
module "nvim"
module "fzf"

# uncomment to know what take to much time at the load and init time
# DOn't forget to uncomment the 'import' at the top of the file
# zprof
