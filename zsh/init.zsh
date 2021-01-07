load "$DOTFILE/zsh/env.sh"
load "$DOTFILE/zsh/zsh_conf.zsh"
load "$DOTFILE/zsh/key_biding.zsh"
load "$DOTFILE/zsh/vim_mode.zsh"
load "$DOTFILE/zsh/alias.sh"

load "$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
load "$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
load "$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"
load "$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"
