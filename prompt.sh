SEP="\ue0b0" # 
CURRENT_BG='NONE'

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"

  if [[ $CURRENT_BG != 'NONE' && $1 != ${CURRENT_BG} ]]; then
    echo -n "%{$bg%F{$CURRENT_BG}%}$SEP%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%}"
  fi

  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [ -n $CURRENT_BG ]; then
    echo -n " %{k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{f%}"
  CURRENT_BG=''
}

function prompt() {
  echo "%K{blue}%F{black}${SEP}%d%K{black}%F{blue}${SEP}%k%f"
}
