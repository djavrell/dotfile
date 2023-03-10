# zmodload zsh/zprof

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

export DOTFILE="$HOME/.bashrc.d"
export SUB_MODULES="$DOTFILE/submodules"

# load all core function
load_func "core"

# this function will be called in the ZSH module (zvm after init)
# due to the vim mode plugin.
function zsh_after_init() {
  module "git"
  module "starship"
  module "fzf"
  module "tmux"
  module "tmuxinator"
  module "navi"
  module "nvim"
}

module "core"
module "zsh"

# uncomment to know what take to much time at the load and init time
# Don't forget to uncomment the 'import' at the top of the file
# zprof
