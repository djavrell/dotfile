load "$SUB_MODULES/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# Vim mode
export ZVM_VI_HIGHLIGHT_BACKGROUND=grey
export ZVM_CURSOR_STYLE_ENABLED=false

function export_zsh_conf() {
  # ZSH Conf
  ## History
  unsetopt hist_ignore_space      # ignore space prefixed commands
  setopt append_history           # append
  setopt hist_ignore_all_dups     # no duplicate
  setopt hist_reduce_blanks       # trim blanks
  setopt hist_verify              # show before executing history commands
  setopt inc_append_history       # add commands as they are typed, don't wait until shell exit
  setopt share_history            # share hist between sessions
  setopt bang_hist                # !keyword

  ## Options setup
  setopt extended_glob            # activate complex pattern globbing
  unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'

  ## Completion
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
}

function export_env() {
  # Env
  export LC_ALL=fr_FR.UTF-8
  export EDITOR="nvim"
  export VISUAL="nvim"
  export MANPAGER="nvim +Man!"
  export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
  # export TERM='tmux-256color-italic'

  export HISTFILE=~/.zsh_history
  export HISTSIZE=1024
  export SAVEHIST=1024

  ## ZSH config
  export COMPLETION_WAITING_DOTS="true"
  export DISABLE_UNTRACKED_FILES_DIRTY="true"

  ## GPG
  export GPG_TTY=$(tty)

  ## SSH
  export SSH_KEY_PATH="~/.ssh/rsa_id"

  ## FNM Node version manager
  export FNM_DIR="$XDG_DATA_HOME/fnm"
  export FNM_LOGLEVEL=quiet

  ## SCALA
  # export SCALA_HOME="/usr/local/share/scala-2.12.6"
  # path=( "$SCALA_HOME/bin" $path)
  path=( "/Users/kpr/Library/Application Support/Coursier/bin" $path )

  ## Go
  export GOPATH="$HOME/go"
  path=( "$GOPATH/bin" $path )

  ## PostgresSQL
  path=( "/opt/homebrew/opt/postgresql@12/bin" $path )

  ## Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
  path=( "$HOME/.rvm/bin" $path )
  load "$HOME/.rvm/scripts/rvm"
}

function export_alias() {
  # Alias
  alias -- -='cd -'
  alias ..='cd ..'
  alias exa='exa --git'
  alias ls='exa'
  alias ll='exa -lh'
  alias la='exa -la'
  alias lat='exa -laT'
  alias lr='exa -lhR'
  alias lt='exa -lhT'

  alias s='source ~/.zshrc'
  alias as='alias | grep $*'

  alias ah='history | grep $*'

  alias rml='rm -vrf $(ls | fzf-tmux -r 30% --multi --reverse)'

  alias pk="ps aux | fzf --reverse --header-lines=1 --bind 'enter:execute(kill -9 {2})'"

  alias ping='prettyping'

  alias dstop='docker stop $(docker ps | rev | cut -d" " -f1 | rev | tail -n +2 | fzf-tmux -r 30% --reverse --multi)'
}

function export_binding() {
  # Binding
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}

function zvm_after_init() {
  load_func "zsh"

  export_zsh_conf
  export_env

  load "$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
  load "$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
  load "$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"

  # from zshrc
  zsh_after_init
  export_alias
  export_binding

  check_eval direnv hook zsh
  check_eval fnm env --use-on-cd
  check_eval scala-cli install completions --env --shell zsh
}
