# FZF fuzzy finder
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --ignore-file ~/.bashrc.d/fdignore"
export FZF_COMPLETION_TRIGGER='%'

load "$DOTFILE/fzf/fzf.zsh"

load "$SUB_MODULES/fzf-marks/init.zsh"
