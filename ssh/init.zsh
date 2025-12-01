if [ -d "$WSL_DISTRO_NAME" ]; then
  export SSH_KEY_PATH="$W_HOME/.ssh/id_rsa"
else
  export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
fi
