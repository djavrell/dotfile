path=( "$DOTFILE/git/git-scripts" $path )

load_func "git"

load "$DOTFILE/git/$SYSTEM_NAME/init.zsh"

# git rev-parse --show-superproject-working-tree
alias groot='cd $(git rev-parse --show-toplevel)'

alias gd='git diff'

alias sync='ggpull && gfo --prune && git fetch --tags --force'
alias brute='ggpush --force-with-lease'

alias gw='git worktree'
alias gwa='gw add'
alias gwl='gw list'
alias gwr='gw remove'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbr='git branch --remote'
alias gbdl='git branch -D $(git branch | fzf --reverse --multi)'
alias gbm='git branch -m $(git_current_branch)'

alias gc='git commit -v'
alias gcm='git commit -v -m'
alias gcm!='git commit -v -m --amend'
alias 'gc!'='git commit -v --amend'
alias 'gcn!'='git commit -v --no-edit --amend'

alias gcl='git clone --recursive'

alias gcb='git checkout -b'
alias move='git checkout $(git branch | sd "[\+* ]" "" | fzf --reverse)'
alias movea='git checkout $(gba | sd "remotes/origin/" "" | sd "[\+* ]" "" | sort | uniq | fzf --reverse)'
alias movet='git checkout $(git tag | fzf --reverse)'
alias 'g-'='git checkout -'
alias master='git checkout $(git symbolic-ref --short refs/remotes/origin/HEAD | cut -d"/" -f2)'
alias develop='git checkout develop'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias ggpull='git pull origin $(git_current_branch)'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'

alias gma='git merge --abort'

alias gitAbort="git reset --hard HEAD"
alias gitSRestore='git restore --staged $(git status --porcelain | cut -d" " -f3 | fzf --reverse --multi)'
alias gitRestore='git restore $(git status --porcelain | cut -d" " -f3 | fzf --reverse --multi)'

alias gsps='git show --pretty=short --show-signature'
alias gs='git show'
alias gssu='git show --summary'
alias gsst='git show --stat'

alias gst='git status --untracked-files'

alias gsth='git stash'
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'

alias gts='git tag -s'
alias gtv='git tag | sort -V'
