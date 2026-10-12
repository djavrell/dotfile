// What the model reads when a guard refuses, and the one line the transcript shows in its place.

// Starts every refusal of this mod, as it started the classic hooks' ones.
const DENY_MARKER = "LSP-FIRST:";

export const grepDenial = (symbols: readonly string[]) =>
  `${DENY_MARKER} grep on code symbol(s) ${symbols.join(", ")}: ask the LSP instead, ` +
  `mcp__cclsp__find_workspace_symbols("${symbols[0]}") then find_references from its definition. ` +
  "Allowed: typings (.d.ts), one known file, regex patterns, -c, -A/-B/-C.";

export const writeDenial = (target: string) =>
  `${DENY_MARKER} writing the source file ${target} from the shell: use Edit (Read it first) or Write, ` +
  "which show a diff and fail loudly on a missing anchor (Edit refuses a non-UTF-8 file: Write it whole). " +
  "Scratch paths (scratchpad/, /tmp) are exempt.";

// This mod's refusal: the error text starts with the marker (a ⛔ before it allowed); its first line is captured.
// An error that merely quotes the marker further in (a grep's output, a log) is no refusal.
const OWN_DENIAL = new RegExp(`^\\s*(?:⛔\\s*)?(${DENY_MARKER}.*)`);

// This mod's refusal as one line, for the transcript; null for any other error, which keeps its own display.
export function compactDenial(errorText: string): string | null {
  const refusalLine = errorText.match(OWN_DENIAL)?.[1];
  return refusalLine ? `⛔ ${refusalLine.trim()}` : null;
}
