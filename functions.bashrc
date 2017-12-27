ghclone() {
  git clone https://github.com/$1/$2.git
}

setZenGit() {
  git config user.email kevin.prouteau@fabernovel.com
  git config user.name "Prouteau Kévin"
}

showEnv() {
  echo $PATH | sed -e 's/:/\'$'\n/g'
}
