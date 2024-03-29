set -a

link_arrow()        { echo -e " $(tput setaf 3)         ➜$(tput sgr0)  $*"; }
link_arrow_sudo()   { echo -e " $(tput setaf 3)         ➜$(tput sgr0)  $*$(tput setaf 4;tput bold) (system)$(tput sgr0)"; }
link_success()      { echo -e " $(tput setaf 2)         ✔$(tput sgr0)  $*"; }
link_success_sudo() { echo -e " $(tput setaf 2)         ✔$(tput sgr0)  $*$(tput setaf 4;tput bold) (system)$(tput sgr0)"; }
link_error()        { echo -e " $(tput setaf 1)         ✖$(tput sgr0)  $*"; }

log_header()      { printf '\r\n \033[01;36m- %s\033[0m\n' "$*"; }
log_topic()       { printf '\r    \033[01;35m+ %s\033[0m\n' "$*"; }
log_info()        { printf '\r          [ \033[00;34mINFO\033[0m ] %s\n' "$*"; }
log_skip()        { printf '\r          [ \033[00;90mSKIP\033[0m ] %s\n' "$*"; }
log_success()     { printf '\r\033[2K          [ \033[00;32mOK\033[0m ] %s\n' "$*"; }
log_warn()        { printf '\r\033[2K          [ \033[0;33mWARN\033[0m ] %s\n' "$*"; }
log_error()       { printf '\r\033[2K          [ \033[0;31mERROR\033[0m ] %s\n' "$*"; }

set +a
