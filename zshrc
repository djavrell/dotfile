# Path to your oh-my-zsh installation.
export ZSH=/Users/kpr/.oh-my-zsh
export DOTFILE=~/.bashrc.d

# TODO: nuke it when oh-my-zsh will be remove
plugins=(
  node npm
  scala
  brew osx
  yarn-autocompletions
)

SYSTEM_FILE=`uname -s | tr '[:upper]' '[:lower:]'`
# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"
fpath=( "$DOTFILE/function.d" $fpath )
autoload -Uz load link sourcesAll

typeset -ga sources

sources+="$ZSH/oh-my-zsh.sh"
sources+="$DOTFILE/env.sh"
sources+="$DOTFILE/alias.sh"
sources+="$DOTFILE/alias_git.sh"

sources+="/.local/share/zsh-syntax-hightlighting/zsh-syntax-highlighting.zsh"
sources+="~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
sources+="$DOTFILE/shell_scripts/fzf-marks/fzf-marks.plugin.zsh"

sources+="${HOME}/.iterm2_shell_integration.zsh"
sources+="$DOTFILE/$SYSTEM_FILE.zsh"
sources+="$DOTFILE/local.sh"

foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    source $file
  fi
end

# Hook for desk activation
[ -n "$DESK_ENV" ] && source "$DESK_ENV" || true
