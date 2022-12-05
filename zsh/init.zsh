load "$SUB_MODULES/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

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

  load "~/.fzf.zsh"

  load "$DOTFILE/starship.sh"
  # check_eval starship init zsh

  check_eval direnv hook zsh
  check_eval fnm env --use-on-cd
  check_eval scala-cli install completions --env --shell zsh
}
