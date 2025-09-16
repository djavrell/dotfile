load_func "zsh"

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

  ## ZSH config
  export COMPLETION_WAITING_DOTS="true"
  export DISABLE_UNTRACKED_FILES_DIRTY="true"
}

function export_env() {
  # GPG (need for nvim plugin)
  export GPG_TTY=$(tty)

  ## SSH
  export SSH_KEY_PATH="$W_HOME/.ssh/id_rsa"

  ## FNM Node version manager
  export FNM_DIR="$XDG_DATA_HOME/fnm"
  export FNM_LOGLEVEL=quiet
}

function export_alias() {
  # Alias
  alias -- -='cd -'
  alias ..='cd ..'
  alias eza='eza'
  alias ls='eza'
  alias ll='eza -lh'
  alias la='eza -la'
  alias lat='eza -laT'
  alias lr='eza -lhR'
  alias lt='eza -lhT'

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

export_zsh_conf
export_env

load "$SUB_MODULES/zsh-hightlighting/zsh-syntax-hightlighting.zsh"
load "$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
load "$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"

load "$DOTFILE/local.zsh"
load "$SYSFILE/init.zsh" # load conf for the current system (linux/darwin/...)
load "$DOTFILE/osc-integration.sh"

module "git"
module "starship"
module "fzf"
module "navi"
module "nvim"
module "rust"
module "python"
module "fnm"

export_alias
export_binding

# check_eval direnv hook zsh
# check_eval scala-cli install completions --env --shell zsh
