# eval $(wsl2-ssh-agent)
export W_HOME="/mnt/c/Users/k.prouteau"

export W_XDG_CONFIG_HOME="$W_HOME/.config"
export W_XDG_DATA_HOME="$W_HOME/.local/share"
export W_XDG_CACHE_HOME="$W_HOME/.local/cache"
export W_XDG_BIN_HOME="$W_HOME/.local/bin"

# Forced on purpose: fixed a WSL issue with fnm (see d01dc54).
# Check that fnm still works before relaxing it to systemd's /run/user/<uid>.
export XDG_RUNTIME_DIR=/tmp/run/user/$(id -u)
mkdir -p $XDG_RUNTIME_DIR

alias ssh='ssh.exe'
