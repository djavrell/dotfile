export CLAUDE_CODE_ENABLE_TELEMETRY=0
export CLAUDE_CODE_NO_FLICKER=1
export CLAUDE_CODE_ENABLE_TODO_TOOLS=1

# one entry per mod folder (each is loaded as a --plugin-dir), joined with ':'
claude_mod_dirs=("$DOTFILE"/claude/mods/*(/N))
export CLAUDE_CODE_PLUGIN_DIRS=${(j.:.)claude_mod_dirs}
unset claude_mod_dirs
