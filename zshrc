export DOTFILE=~/.bashrc.d

# Path to your oh-my-zsh installation.
export ZSH=/Users/kpr/.oh-my-zsh

source $DOTFILE/function.d/source.sh

# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

sourceIt $ZSH/oh-my-zsh.sh

for file in ~/.bashrc.d/*.bashrc
do
	sourceIt "$file"
done
