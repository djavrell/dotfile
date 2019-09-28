export DOTFILE="$HOME/.bashrc.d"

SUB_MODULES="$DOTFILE/submodules"
SYSTEM_FILE=`uname -s | tr '[:upper]' '[:lower:]'`

fpath=( "$DOTFILE/function.d" "$DOTFILE/function.d/**/*~*/" $fpath )
fpath=( "$SUB_MODULES/pure" $fpath )

autoload -Uz load link sourcesAll git_current_branch
autoload -Uz promptinit && promptinit
autoload -Uz colors && colors
autoload -Uz compinit

zmodload -i zsh/complist

# prompt specifics
prompt pure

# export all environement variables
. "$DOTFILE/env.sh"

# source all need script
typeset -ga sources

sources+="$DOTFILE/vim_mode.zsh"
sources+="$DOTFILE/alias.sh"
sources+="$DOTFILE/alias_git.sh"

sources+="$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
sources+="$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
sources+="$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"
sources+="$SUB_MODULES/fzf-marks/fzf-marks.plugin.zsh"

sources+="$DOTFILE/function.d/lazynvm"
sources+="$DOTFILE/$SYSTEM_FILE.zsh"
sources+="$DOTFILE/local.sh"
sources+=$(get_export) # Add sources from env.sh

foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    . $file
  fi
end


# Completion
unsetopt flow_control
unsetopt menu_complete
setopt auto_menu
setopt always_to_end
setopt complete_in_word
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _list _expand _complete _ignored _match _correct _approximate
# zstyle ':completion:*' completions 1
# zstyle ':completion:*' expand prefix suffix
# zstyle ':completion:*' file-sort name
# zstyle ':completion:*' glob 1
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' ignore-parents parent pwd .. directory
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' list-suffixes true
# zstyle ':completion:*' matcher-list '' 'r:|[._-]=* r:|=*'
# zstyle ':completion:*' max-errors 2 numeric
# zstyle ':completion:*' menu select=1
# zstyle ':completion:*' preserve-prefix '//[^/]##/'
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' squeeze-slashes true
# zstyle ':completion:*' substitute 1
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
# zstyle :compinstall filename '/Users/kpr/.zshrc'

if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

# Binding
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# History
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit
setopt share_history            # share hist between sessions
setopt bang_hist                # !keyword

# Options setup
setopt extended_glob            # activate complex pattern globbing
unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'

# VIM Mode

# Hook for desk activation
[ -n "$DESK_ENV" ] && source "$DESK_ENV" || true

# # uncomment to know what take to much time at the load and init time
# zmodload zsh/zprof # top of your .zshrc file
# zprof
