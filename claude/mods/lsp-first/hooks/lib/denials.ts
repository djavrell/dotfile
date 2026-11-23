// What the model reads when a guard refuses, and the one line the transcript shows in its place.

// Starts every refusal of this mod, as it started the classic hooks' ones.
const DENY_MARKER = 'LSP-FIRST:';

// No list of what the guard lets through: sessions read "Allowed: regex patterns" as a way around it and
// searched `Invalid[V]alue`. The refusal names the tool to switch to, and how to load it when deferred.
export const grepDenial = (symbols: readonly string[]) =>
  `${DENY_MARKER} grep on code symbol(s) ${symbols.join(', ')}: ask the LSP instead, ` +
  `mcp__cclsp__find_workspace_symbols("${symbols[0]}") then find_references from its definition ` +
  '(deferred? load them first: ToolSearch "select:mcp__cclsp__find_workspace_symbols,mcp__cclsp__find_references"). ' +
  'Switch tool: the same search reworded (a regex, another shell form) is the same lookup.';

export const writeDenial = (target: string) =>
  `${DENY_MARKER} writing ${target} from the shell: use Edit (Read it first) or Write, for every file type, ` +
  'Markdown included; they show a diff and fail loudly on a missing anchor (Edit refuses a non-UTF-8 file: Write it whole). ' +
  'Switch tool: python/perl/node writing the file, a heredoc or printf >> is the same edit. ' +
  'Scratch paths (scratchpad/, /tmp) are exempt: name them absolute, or relative to a cd in the same command.';

export const readDenial = (target: string) =>
  `${DENY_MARKER} reading the source file ${target} from the shell: use Read with offset/limit, a window around the ` +
  "lines you need (sed -n '120,180p' is offset=120 limit=61), numbered and ready for Edit. " +
  "Allowed: a pipe's output (cmd | head), git show/diff, typings (.d.ts), non-source files, scratch paths.";

// This mod's refusal: the error text starts with the marker (a ⛔ before it allowed); its first line is captured.
// An error that merely quotes the marker further in (a grep's output, a log) is no refusal.
const OWN_DENIAL = new RegExp(`^\\s*(?:⛔\\s*)?(${DENY_MARKER}.*)`);

// This mod's refusal as one line, for the transcript; null for any other error, which keeps its own display.
export function compactDenial(errorText: string): string | null {
  const refusalLine = errorText.match(OWN_DENIAL)?.[1];
  return refusalLine ? `⛔ ${refusalLine.trim()}` : null;
}
