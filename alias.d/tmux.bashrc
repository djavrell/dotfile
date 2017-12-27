# tmux
alias tl='tmux list-sessions'      # list all tmux session
alias ta='tmux a -t $*'            # go into a tmux session
alias tn='tmux new -s $*'          # create a new tmux session
alias tka='tmux kill-session -a'   # kill all tmux session
alias tk='tmux kill-session -t $*' # kill a tmux session
alias tks='tmux kill-server'       # HARD KILL of tmux
