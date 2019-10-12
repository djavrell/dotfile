# General
alias ..='cd ..'
alias -- -='cd -'
alias ls='exa'
alias ll='exa -lh'
alias la='exa -la'
alias s='source ~/.zshrc'
alias as='alias | grep $*'
alias ah='history | grep $*'
alias rml='rm -vrf $(ls | fzf-tmux -r 30% --multi --reverse)'

alias cdroot='cd $(git rev-parse --show-toplevel)'

alias pk="ps | fzf --reverse --header-lines=1 --bind 'enter:execute(kill -9 {1})'"

alias mux='tmuxinator'

alias ping='prettyping'

# tmux
alias tl='tmux list-sessions'      # list all tmux session
alias ta='tmux a -t $*'            # go into a tmux session
alias tla='ta $(tl | cut -d":" -f 1 | fzf-tmux -r 30% --reverse)'
alias tn='tmux new -s $*'          # create a new tmux session
alias tka='tmux kill-session -a'   # kill all tmux session
alias tkl='tk $(tl | cut -d":" -f 1 | fzf-tmux -r 30% --reverse)'
alias tk='tmux kill-session -t $*' # kill a tmux session
alias tks='tmux kill-server'       # HARD KILL of tmux

# ssh -> TODO: Move into local.conf
alias pi='ssh djavrell@192.168.0.14 -p 2424'
alias picp='scp -P 2424 $1 djavrell@192.168.0.14:$2'

# Android
alias emu="$ANDROID_HOME/emulator/emulator"

alias dstop='docker stop $(docker ps | rev | cut -d" " -f1 | rev | tail -n +2 | fzf-tmux -r 30% --reverse --multi)'
