#! /bin/sh

function color() {
  echo -e "$@\e[0m"
}

function white() {
  echo "\e[1;37m$@\e[0m"
}

function red() {
  echo "\e[1;31m$@\e[0m"
}

function light_red() {
  echo "\e[0;33m$@\e[0m"
}

function blue() {
  echo "\e[0;34m$@\e[0m"
}

function light_blue() {
  echo "\e[1;34m$@\e[0m"
}

function yellow() {
  echo "\e[0;33m$@\e[0m"
}

function black() {
  echo "\e[1;30m$@\e[0m"
}

function green() {
  echo "\e[0;32m$@\e[0m"
}

function light_green() {
  echo "\e[1;32m$@\e[0m"
}

function cyan() {
  echo "\e[0;36m$@\e[0m"
}

function light_cyan() {
  echo "\e[1;36m$@\e[0m"
}

function purple() {
  echo "\e[0;35m$@\e[0m"
}

function light_purple() {
  echo "\e[1;35m$@\e[0m"
}

function brown() {
  echo "\e[0;33m$@\e[0m"
}

function light_grey() {
  echo "\e[0;37m$@\e[0m"
}

function test_color() {
  color "$(white "white") $(red "red") $(light_red "light red") $(blue "blue") $(light_blue "light blue") $(yellow "yellow") $(black "black") $(gree "green") $(light_green "light green") $(cyan "cyan") $(light_cyan "light cyan") $(purple "purple") $(light_purple "light purple") $(brown "brown")  $(light_grey "light grey")"
}
