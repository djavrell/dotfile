# FZF fuzzy finder
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --ignore-file $DOTFILE/fdignore"
export FZF_COMPLETION_TRIGGER='%'

# export FZF_CTRL_R_OPTS='--reverse'

# on osx, use this command to generate needed files
# $(brew --prefix)/opt/fzf/install --xdg --no-bash --no-fish --no-update-rc --key-bindings --completion
load "$XDG_CONFIG_HOME/fzf/fzf.zsh"
load "$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}

zle     -N   fzf-history-widget-accept
bindkey '^R' fzf-history-widget-accept
