# General
alias ..='cd ..'
alias -- -='cd -'
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

alias mux='tmuxinator'

alias ping='prettyping'

alias vim="nvim"
alias vimdb="vim +DBUIToggle"
alias vimup="vim +PlugUpdate"

# tmux
alias tl='tmux list-sessions'      # list all tmux session
alias ta='tmux a -t $*'            # go into a tmux session
alias tla='ta $(tl | cut -d":" -f 1 | fzf-tmux -r 30% --reverse)'
alias tn='tmux new -s $*'          # create a new tmux session
alias tka='tmux kill-session -a'   # kill all tmux session
alias tkl='tk $(tl | cut -d":" -f 1 | fzf-tmux -r 30% --reverse)'
alias tk='tmux kill-session -t $*' # kill a tmux session
alias tks='tmux kill-server'       # HARD KILL of tmux

alias dstop='docker stop $(docker ps | rev | cut -d" " -f1 | rev | tail -n +2 | fzf-tmux -r 30% --reverse --multi)'

alias swapLokkup='sudo fs_usage | rg swapfile'
