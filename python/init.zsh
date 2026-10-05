# check_eval pip completion --zsh

# not check_eval: conda is only on PATH once this hook ran; `head -n -1` drops the trailing `conda activate 'base'`
[[ -x "$HOME/anaconda3/bin/conda" ]] && eval "$("$HOME/anaconda3/bin/conda" shell.zsh hook | head -n -1)"
