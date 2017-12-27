alias gitAbort="git reset --hard HEAD"

alias move='git checkout $(git branch | selecta)'
alias fuckit='git commit -m "$(curl -s whatthecommit.com/index.txt)"'