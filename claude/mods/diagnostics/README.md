# diagnostics

Cuts the language server's list of new errors down before the model reads it. A TypeScript error on a typera/zod route
spells out the whole inferred type: one list of 5 errors reached 5.6M chars, more than the context window.

Each line keeps its head (file, line, error code, start of the message) and loses the rest past 400 chars; the whole list
stops at 20k chars. The display does not change: Claude Code already shows that list as one line (ctrl+o unrolls it).

## Example

```
  ✘ [Line 339:60] Argument of type '(request: RequestFor<"/configurations/:configurationId", ZodObject<…… [+2822633 chars]
```
