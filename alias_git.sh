# git rev-parse --show-superproject-working-tree
alias groot='cd $(git rev-parse --show-toplevel)'

function ggroot() {
  local super=$(git rev-parse --show-superproject-working-tree)

  if [[ ! "$super" ]]; then
    return 1
  fi
  cd "$super"
}

function add() {
  git add -v $(git diff --raw | awk '{print $6}' | fzf --reverse --preview="git diff {} | delta" --preview-window=bottom:90%:wrap --multi)
}

function uadd() {
  git add -v $(git ls-files --others --exclude-standard | fzf --reverse --preview="bat --color always {}" --preview-window=right:70%:wrap --multi)
}

alias vadd='vim +MagitOnly'

function gbdll() {
  git branch -vv
}

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

alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit -v'
alias 'gc!'='git commit -v --amend'
alias gca='git commit -v -a'
alias 'gca!'='git commit -v -a --amend'
alias gcam='git commit -a -m'
alias 'gcan!'='git commit -v -a --no-edit --amend'
alias 'gcans!'='git commit -v -a -s --no-edit --amend'
alias gcmsg='git commit -m'
alias 'gcn!'='git commit -v --no-edit --amend'
alias gcs='git commit -S'
alias gcsm='git commit -s -m'
alias fuckit='git commit -m "$(curl -s whatthecommit.com/index.txt)"'

alias gcf='git config --list'

alias gcl='git clone --recursive'

alias gclean='git clean -fd'

alias gco='git checkout'
alias gcb='git checkout -b'
alias gch='git checkout hotfix'
alias gcr='git checkout release'
alias move='git checkout $(git branch | fzf-tmux -r 30% --reverse)'
alias movea='git checkout $(gba | sed -e "s/ remotes\/origin\///g" -e "s/[* ]//g" | sort | uniq | fzf-tmux -r 30% --reverse)'
alias movet='git checkout $(git tag | fzf-tmux -r 30% --reverse)'
alias 'g-'='git checkout -'
alias master='git checkout master'
alias develop='git checkout develop'

alias gcount='git shortlog -sn'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

function gds() {
  git add -v $(git diff --staged --raw | awk '{print $6}' | fzf --reverse --preview="git -c color.diff=always diff --staged {} | delta" --preview-window=right:70%:wrap --multi)
}
function gdl() {
  git diff --raw | awk '{print $6}' | fzf --reverse --multi --preview="git diff {} | delta" --preview-window=bottom:90%
}
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'

alias gdct='git describe --tags `git rev-list --tags --max-count=1`'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias gfl='git flow'
alias gflf='git flow feature'
alias gflff='git flow feature finish'
alias gflfp='git flow feature publish'
alias gflfpll='git flow feature pull'
alias gflfs='git flow feature start'
alias gflh='git flow hotfix'
alias gflhf='git flow hotfix finish'
alias gflhp='git flow hotfix publish'
alias gflhs='git flow hotfix start'
alias gfli='git flow init'
alias gflr='git flow release'
alias gflrf='git flow release finish'
alias gflrp='git flow release publish'
alias gflrs='git flow release start'

alias gg='git gui citool'
alias gga='git gui citool --amend'
alias ggpull='git pull origin $(git_current_branch)'
alias ggpush='git push origin $(git_current_branch) --follow-tags'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gupdate='ggpull && gfo --prune'

function gpush() {
  local branch=$(git_current_branch)

  if [[ $# -eq 0 ]]; then
    echo "gpush <remote_name>+"
  fi

  for remote in "$@"
  do
    color "\npush the commit from $(yellow "$branch") to remote $(red "$remote")\n"
    git push  "$remote" "$branch"
  done
}

alias ghh='git help'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gitVim='vim +GV'

alias gk='\gitk --all --branches'
alias gke='\gitk --all $(git log -g --pretty=%h)'

alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit --all'
alias glp=_git_log_prettily
alias glum='git pull upstream master'

alias gm='git merge'
alias gma='git merge --abort'
alias gmom='git merge origin/master'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/master'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gpu='git push upstream'
alias gpv='git push -v'

alias gpristine='git reset --hard && git clean -dfx'

alias gr='git remote'
alias gra='git remote add'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'

alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gitAbort="git reset --hard HEAD"

alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'

alias grt='cd $(git rev-parse --show-toplevel || echo ".")'

alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'
alias gsb='git status -sb'
alias gsd='git svn dcommit'

alias gsi='git submodule init'

alias gsps='git show --pretty=short --show-signature'
alias gs='git show'
alias gssu='git show --summary'
alias gsst='git show --stat'

alias gsr='git svn rebase'

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

alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'

alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'

