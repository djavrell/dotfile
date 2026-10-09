# lsp-first

Keeps Claude on the LSP for code navigation. It refuses a shell grep on a code symbol (pointing to the LSP call instead) and a shell
write to a source file (pointing to Edit or Write), quietly retries the LSP server when it is not warmed up yet, and shows each
refusal as a single dim line. It replaces the old classic hooks in `~/.claude/hooks/` (unwired; saved in
`claude/hooks-lsp-first.disabled.json`).

## Example

| Command                                 | Verdict                               |
|-----------------------------------------|---------------------------------------|
| `grep -rn "buildAgentTree" src/`        | refused                               |
| `grep -n "flexShrink" types/index.d.ts` | allowed (typings)                     |
| `cat > src/app.ts <<'TS'`               | refused (shell write to `src/app.ts`) |
| `echo x > /tmp/scratch.ts`              | allowed (scratch path)                |

The transcript shows a refusal as one dim line:

```
⛔ LSP-FIRST: grep on code symbol(s) buildAgentTree: ask the LSP instead, mcp__cclsp__find_workspace_symbols("buildAgentTree") then …
```
