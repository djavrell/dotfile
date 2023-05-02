#! /usr/bin/env zsh
# zmodload zsh/zprof

# source "./env.zsh"

function loadMod() {
  local mods=$1
  shift

  for key in "${(ps. .)mods}"; do
    module $key
  done
}

# this function will be called in the ZSH module (zvm after init)
# due to the vim mode plugin.
function zsh_after_init() {
  # loadMod "$postMod"
  module "git"
  module "starship"
  module "fzf"
  module "tmux"
  module "tmuxinator"
  module "navi"
  module "nvim"
  module "kitty"
}

# load all core function
load_func "core"

# loadMod "$preMod"
module "core"
module "zsh"

load "$SYSFILE/init.zsh" # load conf for the current system (linux/darwin/...)
load "$DOTFILE/local.zsh"
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# uncomment to know what take to much time at the load and init time
# Don't forget to uncomment the 'import' at the top of the file
# zprof
