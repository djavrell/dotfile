# General
alias ll='exa -lh'
alias la='exa -la'
alias s='source ~/.zshrc'
alias as='alias | grep $*'
alias rml='rm -vrf $(ls | fzf-tmux -r 30% --multi --reverse)'
alias cat='bat'

alias cdroot='cd $(git rev-parse --show-toplevel)'

# Git
alias gitAbort="git reset --hard HEAD"
alias move='git checkout $(git branch | fzf-tmux -r 30% --reverse)'
alias movea='git checkout $(git branch --all | fzf-tmux -r 30% --reverse)'
alias fuckit='git commit -m "$(curl -s whatthecommit.com/index.txt)"'
alias gitVim='vim +GV'
source ~/.bashrc.d/alias_git.sh

# tmux
alias tl='tmux list-sessions'      # list all tmux session
alias ta='tmux a -t $*'            # go into a tmux session
alias tn='tmux new -s $*'          # create a new tmux session
alias tka='tmux kill-session -a'   # kill all tmux session
alias tk='tmux kill-session -t $*' # kill a tmux session
alias tks='tmux kill-server'       # HARD KILL of tmux

# ssh
alias pi='ssh djavrell@192.168.1.58 -p 2424'
alias picp='scp -P 2424 $1 djavrell@192.168.1.58:$2'

# scala
alias sbtdebug="sbt -jvm-debug 5005"
alias sbt7="sbt -java-home /Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/"
alias sbt7debug="sbt -java-home /Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/ -jvm-debug 5005"
alias activatordebug="activator -jvm-debug 5005"
alias activator7="activator -java-home /Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/"
alias activator7debug="activator -java-home /Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/ -jvm-debug 5005"

# Android
alias emu="$ANDROID_HOME/emulator/emulator"

# Docker

alias dockerElab='docker run --rm -p 27017:27017 -v mongo-elab:/data/db --name mongo-elab mongo:2.6'

alias dstop='docker stop $(docker ps --all | rev | cut -d" " -f1 | rev | tail -n +2 | fzf-tmux -r 30% --reverse --multi)'
