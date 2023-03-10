SYSTEM_FILE=$(uname -s | tr '[:upper:]' '[:lower:]')
export SYSFILE="$DOTFILE/$SYSTEM_FILE"

# XDG spec
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
