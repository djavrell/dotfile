alias gitAbort="git reset --hard HEAD"

alias move='git checkout $(git branch | selecta)'
alias fuckit='git commit -m "$(curl -s whatthecommit.com/index.txt)"'
alias gitVim='vim +GV'
alias rebase='git rebase -i $(git merge-base $(git_current_branch) $1)'
