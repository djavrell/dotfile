# git rev-parse --show-superproject-working-tree
alias groot='cd $(git rev-parse --show-toplevel)'

alias vadd='vim +MagitOnly'

alias sync='ggpull && gfo --prune && git fetch --tags'
alias gcfmt='git commit -m "formating" '
alias fuckit='git commit -m "$(curl -s whatthecommit.com/index.txt)"'
alias bruteforce='ggpush --force'
alias brute='ggpush --force-with-lease'
alias g=git

alias ga='git add'
alias gaa='git add --all'
alias gap='git apply'
alias gapa='git add --patch'
alias gau='git add --update'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbdl='git branch -D $(git branch | fzf-tmux -r 30% --reverse --multi)'

alias gbl='git blame -b -w'

alias gc='git commit -v'
alias gcm='git commit -v -m'
alias gcm!='git commit -v -m --amend'
alias 'gc!'='git commit -v --amend'
alias 'gcn!'='git commit -v --no-edit --amend'
alias gcs='git commit -S'
alias gcsm='git commit -s -m'

alias gcf='git config --list'

alias gcl='git clone --recursive'

alias gclean='git clean -fd'

alias gcb='git checkout -b'
alias move='git checkout $(git branch | fzf --reverse)'
alias movea='git checkout $(gba | sed -e "s/ remotes\/origin\///g" -e "s/[* ]//g" | sort | uniq | fzf --reverse)'
alias movet='git checkout $(git tag | fzf-tmux -r 30% --reverse)'
alias 'g-'='git checkout -'
alias master='git checkout master'
alias develop='git checkout develop'

alias gcount='git shortlog -sn'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'

alias gdct='git describe --tags `git rev-list --tags --max-count=1`'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias ggpull='git pull origin $(git_current_branch)'
alias ggpush='git push origin $(git_current_branch) --follow-tags'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'

alias gma='git merge --abort'
alias gmom='git merge origin/master'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/master'

alias gpristine='git reset --hard && git clean -dfx'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'

alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

alias gitAbort="git reset --hard HEAD"

alias gsps='git show --pretty=short --show-signature'
alias gs='git show'
alias gssu='git show --summary'
alias gsst='git show --stat'

alias gss='git status -s'
alias gst='git status --untracked-files'

alias gsth='git stash'
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'

alias gsu='git submodule update'

alias gts='git tag -s'
alias gtv='git tag | sort -V'

alias gunignore='git update-index --no-assume-unchanged'
