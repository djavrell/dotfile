export COURSIER_HOME="$XDG_DATA_HOME/coursier"
export SCALA_CLI_HOME="$XDG_DATA_HOME/scalacli"
path=(
  "$COURSIER_HOME/bin"
  "$SCALA_CLI_HOME/local-repo/bin"
  $path
)
