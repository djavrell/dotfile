# FZF fuzzy finder
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --ignore-file $DOTFILE/fdignore"
export FZF_COMPLETION_TRIGGER='%'
# 16-color base: fzf draws with the terminal's ANSI colors, so it follows the wezterm theme (nordic) instead of its own 256 palette
export FZF_DEFAULT_OPTS='--color=16'

# export FZF_CTRL_R_OPTS='--reverse'

check_eval fzf --zsh
load "$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}

zle     -N   fzf-history-widget-accept
bindkey '^R' fzf-history-widget-accept
