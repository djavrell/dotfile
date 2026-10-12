# fold-transcript

Folds the noisy rows of the transcript to one dim line; a click on `[+]` unfolds a row in place, `[−]` folds it back (fullscreen,
where the terminal reports clicks). Only the drawing changes: the model reads every result whole.

```
● Bash(ls -la claude/mods)
  [+] 7 lignes · drwxr-xr-x    - kpr  9 oct.  15:09 agents
› [+] Explore · 2 lignes · - hooks.json
```

- Bash results (drawn inside the call's `ToolUse` row) and Agent results (`ToolResult`).
- Agents' reports and task notifications (`UserMessage` from `peer` or `task-notification`), without the harness's hand-back frame.
- Errored results stay whole; `lsp-first` folds its own refusals.
