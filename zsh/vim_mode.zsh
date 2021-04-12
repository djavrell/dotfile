function zvm_after_init() {
  load "$DOTFILE/zsh/zsh_conf.zsh"
  load "$DOTFILE/zsh/key_biding.zsh"
  load "$DOTFILE/zsh/alias.sh"

  load "$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
  load "$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
  load "$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"
  load "$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"

  # load "$DOTFILE/.fzf.zsh"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

export ZVM_VI_HIGHLIGHT_BACKGROUND=grey
export ZVM_CURSOR_STYLE_ENABLED=false
