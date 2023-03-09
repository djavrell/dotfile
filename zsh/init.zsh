load "$SUB_MODULES/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# Vim mode
export ZVM_VI_HIGHLIGHT_BACKGROUND=grey
export ZVM_CURSOR_STYLE_ENABLED=false


function zvm_after_init() {
  load "$DOTFILE/zsh/env.sh"
  load "$DOTFILE/zsh/zsh_conf.zsh"
  load "$DOTFILE/zsh/key_biding.zsh"
  load_alias "zsh"

  load "$DOTFILE/zsh/sub_modules.zsh"

  load "~/.fzf.zsh"

  load "$DOTFILE/starship.sh"
  # check_eval starship init zsh

  check_eval direnv hook zsh
  check_eval fnm env --use-on-cd
  check_eval scala-cli install completions --env --shell zsh
}

load "$SYSFILE/init.zsh" # load conf for the current system (linux/darwin/...)
load "$DOTFILE/local.sh"
