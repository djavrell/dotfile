# lsp-first

Keeps Claude on the LSP for code navigation. It refuses a shell grep on a code symbol (pointing to the LSP call instead), a shell
read of a source file (pointing to Read with offset/limit) and a shell write to a source file (pointing to Edit or Write), quietly
retries the LSP server when it is not warmed up yet, and shows each refusal as a single dim line.

## Example

| Command                                 | Verdict                               |
|-----------------------------------------|---------------------------------------|
| `grep -rn "buildAgentTree" src/`        | refused                               |
| `grep -n "flexShrink" types/index.d.ts` | allowed (typings)                     |
| `cat > src/app.ts <<'TS'`               | refused (shell write to `src/app.ts`) |
| `echo x > /tmp/scratch.ts`              | allowed (scratch path)                |
| `sed -n '120,180p' src/x.ts`            | refused (shell read of `src/x.ts`)    |
| `npm run build 2>&1 \| tail -30`        | allowed (reads a pipe)                |

The transcript shows a refusal as one dim line:

```
⛔ LSP-FIRST: grep on code symbol(s) buildAgentTree: ask the LSP instead, mcp__cclsp__find_workspace_symbols("buildAgentTree") then …
```
