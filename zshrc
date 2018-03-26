export DOTFILE=~/.bashrc.d

# Path to your oh-my-zsh installation.
export ZSH=/Users/kpr/.oh-my-zsh

source $DOTFILE/function.d/source.sh

# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

for file in ~/.bashrc.d/config/*.sh
do
  source $file
done
