// What the grep and write guards share about a shell command.

// Zero-width and formatting characters could split a word invisibly (`grep​UserService`) and slip past
// every check below: they are removed before anything is matched.
const ZERO_WIDTH_CHARACTERS = /[­​-‏⁠-⁤﻿]/g;

export const cleanCommand = (rawCommand: string) => rawCommand.trim().replace(ZERO_WIDTH_CHARACTERS, "");

// The extensions of the source files an LSP indexes, as a regex fragment.
export const SOURCE_EXTENSION = String.raw`\.(?:ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|vue|svelte|cpp|c|h|hpp)`;

// Closes SOURCE_EXTENSION: without it the `.c` extension would match the start of `data.csv`.
export const EXTENSION_END = String.raw`(?![A-Za-z0-9_])`;

// A heredoc's body is payload, not command: the TypeScript inside `cat > a.ts <<'TS'` would otherwise read as
// redirects (`=>`) and source paths (`import "./x.ts"`), and a PR body quoting a grep would read as one.
// The body goes, its header line stays.
export function withoutHeredocBodies(command: string) {
  const heredocStart = /<<-?\s*(['"]?)([A-Za-z_]\w*)\1/g;
  let stripped = command;
  for (const match of command.matchAll(heredocStart)) {
    const delimiter = match[2];
    const bodyStart = command.indexOf("\n", match.index);
    if (bodyStart === -1) continue;
    const bodyEnd = command.search(new RegExp(`\\n\\s*${delimiter}\\s*(?:\\n|$)`));
    const body = bodyEnd === -1 ? command.slice(bodyStart) : command.slice(bodyStart, bodyEnd);
    if (body) stripped = stripped.split(body).join("\n");
  }
  return stripped;
}
