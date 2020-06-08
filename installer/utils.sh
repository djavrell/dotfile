#! /bin/sh
set -e

# $1: file to source
function loading() {
  if [[ -f "$1" ]]; then
    source "$1"
  fi
}
