#! /bin/sh

# $1: cmd to test
function exec_cmd() {
  which $1 > /dev/null 2>&1
  if [ $? -eq 1 ]; then
    $2
  else
    echo "cmd $1 was not found"
  fi
}
