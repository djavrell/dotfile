if [ "$SYSTEM" = "WSL" ]; then
  alias icat='wezterm.exe imgcat'
else
  alias icat='wezterm imgcat'
fi
