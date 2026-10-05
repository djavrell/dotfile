# check_eval pip completion --zsh

# conda's hook starts python (~340 ms): run it on first `conda` call only.
# condabin goes on PATH now so the binary is visible (dots health, scripts); the function shadows it.
# `head -n -1` drops the trailing `conda activate 'base'`
if [[ -x "$HOME/anaconda3/bin/conda" ]]; then
  path+=("$HOME/anaconda3/condabin")

  function conda() {
    unfunction conda
    eval "$("$HOME/anaconda3/bin/conda" shell.zsh hook | head -n -1)"
    conda "$@"
  }
fi
