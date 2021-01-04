# zmodload zsh/zprof # top of your .zshrc file

autoload -Uz colors && colors
autoload -Uz compinit

zmodload -i zsh/complist

DOTFOLDER=".bashrc.d"
export DOTFILE="$HOME/$DOTFOLDER"

export SUB_MODULES="$DOTFILE/submodules"
SYSTEM_FILE=`uname -s | tr '[:upper:]' '[:lower:]'`

local function load_func() {
  for func in $(ls "$1"); do
    autoload -Uz $func
  done
}

load_func "$DOTFILE/function.d"
load_func "$DOTFILE/git/function.d"

# prevent the global variable PATH to have duplicate
typeset -U path

# source all needed scripts
typeset -ga sources

# export all environement variables
. "$DOTFILE/env.sh"

sources+="$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
sources+="$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
sources+="$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"
sources+="$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"
sources+="$DOTFILE/vim_mode.zsh"

sources+="$DOTFILE/colors.sh"
sources+="$DOTFILE/alias.sh"
sources+="$DOTFILE/alias_git.sh"

sources+="$DOTFILE/$SYSTEM_FILE.zsh"
sources+="$DOTFILE/completion.zsh"
sources+="$DOTFILE/key_biding.zsh"
sources+="$DOTFILE/zsh_opt.zsh"
sources+=$(get_export) # Add sources from env.sh
sources+="$DOTFILE/local.sh"

foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    . $file
  fi
end

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

# uncomment to know what take to much time at the load and init time
# DOn't forget to uncomment the 'import' at the top of the file
# zprof
