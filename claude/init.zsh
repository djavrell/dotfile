export CLAUDE_CODE_ENABLE_TELEMETRY=0
export CLAUDE_CODE_NO_FLICKER=1
export CLAUDE_CODE_ENABLE_TODO_TOOLS=1

# one entry per mod folder (each is loaded as a --plugin-dir), joined with ':'
mods=($HOME/.bashrc.d/claude/mods/*(/N))
export CLAUDE_CODE_PLUGIN_DIRS=${(j.:.)mods}
unset mods
