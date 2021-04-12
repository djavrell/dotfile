load "$DOTFILE/zsh/env.sh"

load "$SUB_MODULES/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
load "$DOTFILE/zsh/vim_mode.zsh"

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"
