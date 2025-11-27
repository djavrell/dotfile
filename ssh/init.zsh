local SSH_HOME="$$HOME/.ssh/id_rsa"

if [ -d "$WSL_DISTRO_NAME" ]; then
  SSH_HOME="$W_HOME/.ssh/id_rsa"
else

export SSH_KEY_PATH="$SSH_HOME"
