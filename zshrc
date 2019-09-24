export DOTFILE=~/.bashrc.d

SUB_MODULES="$DOTFILE/submodules"
SYSTEM_FILE=`uname -s | tr '[:upper]' '[:lower:]'`

fpath=( "$DOTFILE/function.d" "$DOTFILE/function.d/**/*~*/" $fpath )
fpath=( "$SUB_MODULES/pure" $fpath )
autoload -Uz load link sourcesAll git_current_branch
autoload -Uz promptinit && promptinit && prompt pure
autoload -Uz colors && colors
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

zmodload -i zsh/complist

typeset -ga sources

sources+="$DOTFILE/env.sh"
sources+="$DOTFILE/alias.sh"
sources+="$DOTFILE/alias_git.sh"

sources+="$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
sources+="$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
sources+="$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"
sources+="$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"

sources+="$DOTFILE/function.d/lazynvm"
sources+="$DOTFILE/$SYSTEM_FILE.zsh"
sources+="$DOTFILE/local.sh"

foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    source $file
  fi
end


# Completion
setopt auto_menu
setopt always_to_end
setopt complete_in_word
unsetopt flow_control
unsetopt menu_complete
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Binding

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'

# Hook for desk activation
[ -n "$DESK_ENV" ] && source "$DESK_ENV" || true

# # uncomment to know what take to much time at the load and init time
# zmodload zsh/zprof # top of your .zshrc file
# zprof
