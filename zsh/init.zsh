load_func "zsh"

function export_zsh_conf() {
  # ZSH Conf
  ## History
  setopt hist_ignore_space        # don't save space prefixed commands
  setopt hist_ignore_all_dups     # no duplicate
  setopt hist_reduce_blanks       # trim blanks
  setopt hist_verify              # show before executing history commands
  setopt share_history            # write as typed and share between sessions (implies the append options)
  setopt bang_hist                # !keyword

  ## Options setup
  setopt extended_glob            # activate complex pattern globbing
  setopt interactive_comments     # allow `# comment` on the command line
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
  zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
  zstyle ':completion:*' list-colors ''
  zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
}

function export_alias() {
  # Alias
  alias -- -='cd -'
  alias ..='cd ..'
  alias ls='eza'
  alias ll='eza -lh'
  alias la='eza -la'
  alias lat='eza -laT'
  alias lr='eza -lhR'
  alias lt='eza -lhT'

  # exec: replace this shell with a fresh one, re-sourcing would duplicate hooks
  alias s='exec zsh'
  alias as='alias | grep'

  # `history` alone only lists the last 16 events
  alias ah='history 1 | grep'

  alias pk="ps aux | fzf --reverse --header-lines=1 --bind 'enter:execute(kill -9 {2})'"

  alias ping='prettyping'

  alias dstop='docker stop $(docker ps | rev | cut -d" " -f1 | rev | tail -n +2 | fzf-tmux -r 30% --reverse --multi)'

  alias clipboard='xclip -sel c <'
}

function export_binding() {
  # Binding
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  # same arrows in application mode (^[OA / ^[OB)
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

  bindkey '^[[1;5D' backward-word
  bindkey '^[[1;5C' forward-word

  # Shift-Tab: walk the completion list backwards
  bindkey '^[[Z' reverse-menu-complete
  bindkey -M menuselect '^[[Z' reverse-menu-complete
}

export_zsh_conf

load "$SUB_MODULES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
load "$SUB_MODULES/zsh-autosuggestions/zsh-autosuggestions.zsh"
load "$SUB_MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh"

load "$DOTFILE/modules.zsh"
load "$DOTFILE/local.zsh"
load "$SYSFILE/init.zsh" # load conf for the current system (system/wsl, system/linux, ...)
load "$DOTFILE/osc-integration.sh"

# zsh is this very module, already loaded by zshrc
for m in ${${mods:|mods_off}:#zsh}; do
  module "$m"
done

export_alias
export_binding

# check_eval direnv hook zsh
# check_eval scala-cli install completions --env --shell zsh
