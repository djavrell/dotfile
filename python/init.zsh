load "$DOTFILE/python/$SYSTEM_NAME/init.zsh"

# check_eval pip completion --zsh

eval "$(/home/kpr/anaconda3/bin/conda shell.zsh hook | head -n -1)"
