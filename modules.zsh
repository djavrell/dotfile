# vim: ft=zsh
# Single source of truth for modules, read by the shell (zsh/init.zsh) and by `dots`.
# Per machine, tweak both arrays in local.zsh: `mods+=(x)`, `mods_off+=(x)`.

# lifecycle: `dots link | unlink | health` (core is always loaded and has nothing to manage)
typeset -gU mods=(
  zsh
  gpg
  git
  starship
  fzf
  navi
  nvim
  rust
  python
  fnm
  goose
  wezterm
  opencode
  claude
  lua
)

# kept in the lifecycle, but not loaded at shell startup
typeset -gU mods_off=()
