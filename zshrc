export DOTFILE=~/.bashrc.d

# Path to your oh-my-zsh installation.
export ZSH=/Users/kpr/.oh-my-zsh

# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh
source "$DOTFILE/alias.sh"
source "$DOTFILE/env.sh"

#source ~/.local/share/zsh-completions/zsh-completions.plugin.zsh
source ~/.local/share/zsh-syntax-hightlighting/zsh-syntax-highlighting.zsh
#source ~/.local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

plugins=(
  git github git-prompt git-flow gitfast
  node npm
  scala
  colored-man colorize
  brew osx
  zsh-syntax-highlighting zsh-wakatime
  yarn-autocompletions
)

OLD_PATH=$PATH

#NEW_PATH=$( echo $PATH | sed -e 's/:/\'$'\n'/g' | sort -u | sed -e 's/\'$'\n'/:/g' )
