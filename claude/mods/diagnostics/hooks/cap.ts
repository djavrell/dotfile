// a TypeScript error on a typera/zod route spells out the whole inferred type: one message reached 2.8M chars (six-942)
export const MAX_LINE_CHARS = 400
export const MAX_TOTAL_CHARS = 20_000

// keeps every line's head (file, line, code, the start of the message) and drops the spelled-out types
export const capDiagnostics = (text: string) => {
  const lines = text
    .split('\n')
    .map(line => (line.length > MAX_LINE_CHARS ? `${line.slice(0, MAX_LINE_CHARS)}… [+${line.length - MAX_LINE_CHARS} chars]` : line))
  const capped = lines.join('\n')
  return capped.length > MAX_TOTAL_CHARS
    ? `${capped.slice(0, MAX_TOTAL_CHARS)}\n… [diagnostics cut: +${capped.length - MAX_TOTAL_CHARS} chars]`
    : capped
}
