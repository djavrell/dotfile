# General
alias ..='cd ..'
alias -- -='cd -'
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
