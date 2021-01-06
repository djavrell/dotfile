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

DOTFOLDER=".bashrc.d"
SYSTEM_FILE=`uname -s | tr '[:upper:]' '[:lower:]'`

export DOTFILE="$HOME/$DOTFOLDER"
export SUB_MODULES="$DOTFILE/submodules"
export SYSFILE="$DOTFILE/$SYSTEM_FILE"

fpath=( "$DOTFILE/function.d" $fpath )
load_func "$DOTFILE/function.d"

# prevent the global variable PATH to have duplicate
typeset -U path

# export all environement variables
load "$DOTFILE/env.sh"
load "$DOTFILE/git/init.zsh"

load "$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
load "$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
load "$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"
load "$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"

load "$DOTFILE/zsh_conf.zsh"
load "$DOTFILE/key_biding.zsh"
load "$DOTFILE/vim_mode.zsh"
load "$DOTFILE/alias.sh"

load "$SYSFILE/init.zsh"
load "$DOTFILE/local.sh"

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

# uncomment to know what take to much time at the load and init time
# DOn't forget to uncomment the 'import' at the top of the file
# zprof
