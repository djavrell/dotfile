# Path to your oh-my-zsh installation.
export ZSH=/Users/kpr/.oh-my-zsh
export DOTFILE=~/.bashrc.d

# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh
source "$DOTFILE/env.sh"
source "$DOTFILE/alias.sh"
source "$DOTFILE/gruvbox_256palette_osx.sh"

source ~/.local/share/zsh-syntax-hightlighting/zsh-syntax-highlighting.zsh
source ~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source "$DOTFILE/shell_scripts/fzf-marks/fzf-marks.plugin.zsh"

plugins=(
  node npm
  scala
  brew osx
  yarn-autocompletions
)

# Auto completion

## The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/kpr/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/kpr/Downloads/google-cloud-sdk/path.zsh.inc'; fi

## The next line enables shell command completion for gcloud.
# if [ -f '/Users/kpr/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/kpr/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Hook for desk activation
[ -n "$DESK_ENV" ] && source "$DESK_ENV" || true
