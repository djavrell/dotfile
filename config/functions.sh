ghclone() {
  git clone https://github.com/$1/$2.git
}

showEnv() {
  echo $PATH | sed -e 's/:/\'$'\n/g'
}
