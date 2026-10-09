// What the model reads when a guard refuses, and the one line the transcript shows in its place.

// Starts every refusal of this mod, as it started the classic hooks' ones.
const DENY_MARKER = "LSP-FIRST:";

export const grepDenial = (symbols: readonly string[]) =>
  `${DENY_MARKER} grep on code symbol(s) ${symbols.join(", ")}: ask the LSP instead, ` +
  `mcp__cclsp__find_workspace_symbols("${symbols[0]}") then find_references from its definition. ` +
  "Allowed: typings (.d.ts), one known file, regex patterns, -c, -A/-B/-C.";

export const writeDenial = (target: string) =>
  `${DENY_MARKER} writing the source file ${target} from the shell: use Edit (Read it first) or Write, ` +
  "which show a diff and fail loudly on a missing anchor. Scratch paths (scratchpad/, /tmp) are exempt.";

// The classic hooks prefixed their refusals: `PreToolUse:Bash hook error: [node ~/.claude/hooks/x.js]: ⛔ ...`.
const CLASSIC_HOOK_PREFIX = /^[^]*?(?=⛔|LSP-FIRST|TOOL-CHOICE)/;

// An LSP-first refusal (this mod's, or a classic hook's: LSP-FIRST or TOOL-CHOICE) as its first line, for the
// transcript; null for any other error, which keeps its own display.
export function compactDenial(errorText: string): string | null {
  if (!/LSP-FIRST|TOOL-CHOICE/.test(errorText)) return null;
  const lines = errorText
    .replace(CLASSIC_HOOK_PREFIX, "")
    .split("\n")
    .map((line) => line.replace(/^⛔\s*/, "").trim());
  return `⛔ ${lines.find(Boolean) ?? ""}`;
}
