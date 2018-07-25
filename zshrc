export DOTFILE=~/.bashrc.d

# Path to your oh-my-zsh installation.
export ZSH=/Users/kpr/.oh-my-zsh

# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh
source "$DOTFILE/env.sh"
source "$DOTFILE/alias.sh"

source ~/.local/share/zsh-syntax-hightlighting/zsh-syntax-highlighting.zsh
source ~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

plugins=(
  git
  node npm
  scala
  brew osx
  yarn-autocompletions
)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kpr/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/kpr/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kpr/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/kpr/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
