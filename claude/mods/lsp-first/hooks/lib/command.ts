// What the grep and write guards share about a shell command.

// Zero-width and formatting characters could split a word invisibly (`grep​UserService`) and slip past
// every check below: they are removed before anything is matched.
const ZERO_WIDTH_CHARACTERS = /[­​-‏⁠-⁤﻿]/g;

export const cleanCommand = (rawCommand: string) => rawCommand.trim().replace(ZERO_WIDTH_CHARACTERS, "");

// The extensions of the source files an LSP indexes, as a regex fragment.
export const SOURCE_EXTENSION = String.raw`\.(?:ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|vue|svelte|cpp|c|h|hpp)`;

// Closes SOURCE_EXTENSION: without it the `.c` extension would match the start of `data.csv`.
export const EXTENSION_END = String.raw`(?![A-Za-z0-9_])`;
