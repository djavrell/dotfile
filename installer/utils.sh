#! /bin/sh
set -e

# $1: file to source
function loading() {
  if [[ -f "$1" ]]; then
    source "$1"
  fi
}

function run() {
  if [[ -f "$1" ]]; then
    echo "$PWD"
    echo "will run $1 script"
    ./"$1"
  fi
}
