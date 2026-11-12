// What the grep, read and write guards share about a shell command.

// Zero-width and formatting characters could split a word invisibly (`grep​UserService`) and slip past
// every check below: they are removed before anything is matched.
const ZERO_WIDTH_CHARACTERS = /[­​-‏⁠-⁤﻿]/g;

export const cleanCommand = (rawCommand: string) => rawCommand.trim().replace(ZERO_WIDTH_CHARACTERS, '');

// The extensions of the source files an LSP indexes, as a regex fragment.
export const SOURCE_EXTENSION = String.raw`\.(?:ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|vue|svelte|cpp|c|h|hpp)`;

// Closes SOURCE_EXTENSION: without it the `.c` extension would match the start of `data.csv`.
export const EXTENSION_END = String.raw`(?![A-Za-z0-9_])`;

// Where a path is no project code: scratch space, VCS internals, build output.
const SCRATCH_OR_TOOLING_PATH =
  /(?:^|[/\\])(?:\.claude|\.git|\.task|coverage|\.next|\.turbo|knowledge-vault|node_modules[/\\]\.bin)(?:[/\\]|$)|(?:^|[/\\])(?:scratchpad|tmp|temp)[/\\]|^\/tmp[/\\]/i;

export const isScratchOrToolingPath = (path: string) => SCRATCH_OR_TOOLING_PATH.test(path);

// The pipeline and list parts (`a | b; c && d`), split outside quotes only, each without its leading
// `VAR=value` assignments and sudo/command wrappers, so each is judged by the program it runs.
export function commandParts(command: string) {
  const parts: string[] = [];
  let currentPart = '';
  let openQuote: string | null = null;
  for (let index = 0; index < command.length; index++) {
    const character = command[index]!;
    const isEscaped = command[index - 1] === '\\';
    if (openQuote) {
      if (character === openQuote && !isEscaped) openQuote = null;
      currentPart += character;
    } else if (character === '"' || character === "'") {
      openQuote = character;
      currentPart += character;
    } else if ('|;\n&'.includes(character)) {
      parts.push(currentPart);
      currentPart = '';
    } else {
      currentPart += character;
    }
  }
  parts.push(currentPart);
  return parts
    .map((part) => part.trim().replace(/^(?:\w+=\S*\s+)*(?:sudo\s+|command\s+)?/, '').trim())
    .filter(Boolean);
}

// A part that only changes directory (`cd scratch`).
export const CD_TARGET = /^cd\s+['"]?([^'"\s]+)['"]?$/;

// A relative path under the directory a `cd` in the command moved to; an absolute or home path as is.
export const joinPath = (directory: string, path: string) =>
  !directory || /^[/~]/.test(path) ? path : `${directory.replace(/\/$/, '')}/${path}`;

// A heredoc's body is payload, not command: the TypeScript inside `cat > a.ts <<'TS'` would otherwise read as
// redirects (`=>`) and source paths (`import "./x.ts"`), and a PR body quoting a grep would read as one.
// The body goes, its header line stays.
export function withoutHeredocBodies(command: string) {
  const heredocStart = /<<-?\s*(['"]?)([A-Za-z_]\w*)\1/g;
  let stripped = command;
  for (const match of command.matchAll(heredocStart)) {
    const delimiter = match[2];
    const bodyStart = command.indexOf('\n', match.index);
    if (bodyStart === -1) continue;
    const bodyEnd = command.search(new RegExp(`\\n\\s*${delimiter}\\s*(?:\\n|$)`));
    const body = bodyEnd === -1 ? command.slice(bodyStart) : command.slice(bodyStart, bodyEnd);
    if (body) stripped = stripped.split(body).join('\n');
  }
  return stripped;
}
