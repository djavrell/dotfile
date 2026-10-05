# LSP-First Navigation (CRITICAL)

When cclsp MCP connected, ALL agents MUST use LSP over Grep for semantic navigation.

| Task | LSP Tool |
|------|----------|
| Definition | `find_definition` |
| References | `find_references` |
| Symbol search | `find_workspace_symbols` |
| Implementations | `find_implementation` |
| Call hierarchy | `get_incoming_calls` / `get_outgoing_calls` |
| Type info | `get_hover` |
| Diagnostics | `get_diagnostics` |

Grep/Glob = fallback ONLY when LSP returns empty or searching non-symbol text.

## After locating: read the window, not the file

An LSP call returns `file:line`. That is a coordinate — use it.

    find_definition("parseConfig")         ->  src/config/parse-config.ts:42
    Read(path, offset=22, limit=60)        ->  the function and its context

Read the whole file only when you actually need the whole file (a barrel, a
short module, a file you are about to restructure). Default to a window around
the line LSP gave you, and widen if it turns out to be too narrow.

Rough cost, measured on a real session: LSP locate ~100 tok, ranged Read ~500,
full-file Read of a mid-size module ~3,000. Whole-file reads were the single
largest tool-output consumer in that session — larger than every grep combined.

Same rule for editing: `Edit` needs the file registered by a prior `Read`, and
a ranged `Read` registers it just as well as a full one.

## Where the tokens actually are

Tool output is ~0.1% of a session's token bill; context re-read per turn is
~99%. So the order that matters is:

1. **Delegate exploration to a subagent.** Its tool output never enters this
   context — only its summary does. This is the only order-of-magnitude lever.
2. **Fewer turns.** Every turn re-reads the whole context. Batch independent
   tool calls into one message.
3. **Then** worry about individual result sizes.

Corollary: never trade a turn to save a few hundred tokens of output. A retry
costs more than the verbose result it avoided.
