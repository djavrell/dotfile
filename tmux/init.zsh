load_func "tmux"

alias tl='tmux list-sessions'      # list all tmux session
alias ta='tmux a -t $*'            # go into a tmux session
alias tla='ta $(tl | cut -d":" -f 1 | fzf-tmux -r 30% --reverse)'
alias tn='tmux new -s $*'          # create a new tmux session
alias tka='tmux kill-session -a'   # kill all tmux session
alias tkl='tk $(tl | cut -d":" -f 1 | fzf-tmux -r 30% --reverse)'
alias tk='tmux kill-session -t $*' # kill a tmux session
alias tks='tmux kill-server'       # HARD KILL of tmux
