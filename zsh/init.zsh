load "$SUB_MODULES/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
# load "$DOTFILE/zsh/vim_mode.zsh"

function zvm_after_init() {
  load "$DOTFILE/zsh/env.sh"
  load "$DOTFILE/zsh/zsh_conf.zsh"
  load "$DOTFILE/zsh/key_biding.zsh"
  load "$DOTFILE/zsh/alias.sh"

  load "$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
  load "$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
  load "$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"
  load "$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"

  load "$DOTFILE/zsh/navi.zsh"

  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  eval "$(direnv hook zsh)"
  eval "$(starship init zsh)"
  eval "$(fnm env --use-on-cd)"
}
