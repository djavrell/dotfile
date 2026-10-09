// Shell greps that look up a code symbol. An LSP lookup answers those better (the exact definition, the real
// references), so the guard refuses them and names the LSP call to make instead.
// Ported from the classic hook bash-grep-block.js.
import { cleanCommand } from "./command";

const SEARCH_PROGRAM = /\b(grep|rg|ag|ack)\b/i;

// ── exemptions ───────────────────────────────────────────────────────────────
// A grep that is no symbol lookup, or one no LSP call can answer, runs untouched.

type Exemption = { reason: string; applies: (command: string) => boolean };

// Programs whose output a piped grep filters: that text is no code an LSP knows.
const OUTPUT_PRODUCER =
  /^(?:npm|npx|pnpm|yarn|node|deno|bun|git|docker|make|kubectl|tsc|eslint|jest|vitest|ps|env|printenv|ls|find|wc|sort|uniq|head|tail|curl|dig)\b/i;

// `npm test | grep FailedTest`: the grep reads a program's output, not files.
function filtersProgramOutput(command: string) {
  const pipeIndex = command.indexOf("|");
  const searchIndex = command.search(SEARCH_PROGRAM);
  const grepComesAfterPipe = pipeIndex !== -1 && pipeIndex < searchIndex;
  // with xargs or -exec the grep reads files again, whatever comes before the pipe
  if (!grepComesAfterPipe || /\bxargs\b|-exec\b/.test(command)) return false;
  const producer = command
    .slice(0, pipeIndex)
    .trim()
    .replace(/^\S*=\S*\s+/, ""); // a leading `VAR=value` is no program
  return OUTPUT_PRODUCER.test(producer);
}

const RECURSIVE_FLAG = /\s-\w*[rR]\w*\b|--recursive|--include/i;
const SOURCE_FILE_ARGUMENT =
  /(?:^|\s)['"]?[\w./@~-]+\.(?:ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|vue|svelte)['"]?(?=\s|$|\||;)/gi;

// `grep -n "UserService" user.service.ts`: "where in this file" is cheaper by grep than by any LSP call.
function searchesOneKnownFile(command: string) {
  if (RECURSIVE_FLAG.test(command)) return false;
  return (command.match(SOURCE_FILE_ARGUMENT) ?? []).length === 1;
}

// Paths that point at code: a search naming one is a search of code.
const CODE_PATH = /\bsrc[\\/]|\bapp[\\/]|components[\\/]|lib[\\/]|hooks[\\/]|utils[\\/]|services[\\/]|actions[\\/]/i;
const CODE_SEARCH_HINTS = [
  CODE_PATH,
  /\.tsx?\b|\.jsx?\b/i,
  /-t\s+(ts|tsx|js|jsx|typescript|javascript)\b/i,
  /--type[= ](ts|tsx|js|jsx|typescript)\b/i,
  /\bfind\b.*\b(src|app|components|lib)\b/,
  /\bxargs\b.*\b(grep|rg|ag|ack)\b/i,
  /-exec\s+(grep|rg|ag|ack)\b/i,
];
const NON_CODE_FILE = /\.(sql|md|json|yaml|yml|txt|env|sh|css|scss|log|toml|xml)\b/i;

// `grep -r "UserService" docs/notes.md`: only non-code files are named, and nothing points at code.
function searchesOnlyNonCodeFiles(command: string) {
  const pointsAtCode = CODE_SEARCH_HINTS.some((hint) => hint.test(command));
  return NON_CODE_FILE.test(command) && !pointsAtCode;
}

const GREP_EXEMPTIONS: Exemption[] = [
  {
    reason: "git grep: a deliberate search of the git index",
    applies: (command) => /\bgit\s+grep\b/i.test(command),
  },
  {
    reason: "typings (.d.ts): no LSP index holds their members (csstype's flexShrink), grep is the only way in",
    applies: (command) => /\.d\.ts\b/.test(command),
  },
  {
    reason: "-v drops lines: nobody looks for a definition by excluding it",
    applies: (command) => /\b(?:grep|rg|ag|ack)\s+(?:-\w*v\w*|--invert-match)\b/i.test(command),
  },
  {
    reason: "a filter on another program's output, not a search of files",
    applies: filtersProgramOutput,
  },
  {
    reason: "a tree that holds no indexed code (node_modules, migrations, .claude, notes)",
    applies: (command) =>
      // the tree name starts an argument (after a space or a quote) or a path segment (after a slash)
      /(?:^|[\s'"/\\])(?:supabase[/\\]migrations|\.task|\.claude|node_modules|knowledge-vault)(?:[/\\]|$)/i.test(command),
  },
  {
    reason: "--include of non-code files only",
    applies: (command) => /--include=?\S*\.(sql|md|json|yaml|yml|txt|env|sh|css|scss|log)\b/i.test(command),
  },
  {
    reason: "one known file: grep finds the line cheaper than any LSP call",
    applies: searchesOneKnownFile,
  },
  {
    reason: "-c counts occurrences: LSP has no count",
    applies: (command) => /\b(?:grep|rg|ag|ack)\s+(?:-\w*c\w*|--count)\b/i.test(command),
  },
  {
    reason: "-A/-B/-C asks for the lines around: LSP answers positions only",
    applies: (command) => /\s-[ABC]\s?\d|--(?:after|before)-context\b|--context\b/i.test(command),
  },
  {
    reason: "only non-code files are searched",
    applies: searchesOnlyNonCodeFiles,
  },
];

// ── the pattern and its symbols ──────────────────────────────────────────────

// The searched pattern: double-quoted, single-quoted, or a bare PascalCase word.
function searchPattern(command: string) {
  const unescaped = command.replace(/\\"/g, '"');
  const doubleQuoted = unescaped.match(/\b(?:grep|rg|ag|ack)\s+(?:-\S+\s+)*"([^"]+)"/i);
  const singleQuoted = unescaped.match(/\b(?:grep|rg|ag|ack)\s+(?:-\S+\s+)*'([^']+)'/i);
  const bareWord = unescaped.match(/\b(?:grep|rg|ag|ack)\s+(?:(?:-\w+\s+(?:[a-z]+\s+)?)*?)([A-Z][a-zA-Z]\w+)/i);
  return (doubleQuoted ?? singleQuoted ?? bareWord)?.[1];
}

// `build.*Tree`, `Optional?`: an unescaped wildcard or quantifier makes a regex, and LSP looks up exact names only.
// An escaped dot (`UserService\.`) is still a name; `\\` pairs are dropped first so `\\.` reads as an escape.
const isRegex = (pattern: string) => /(?<!\\)[.?*+[]/.test(pattern.replace(/\\\\/g, ""));

// Words that look like identifiers but are none.
const NOT_SYMBOLS = [
  /^(TODO|FIXME|HACK|XXX|NOTE)/i,
  /^console\b/,
  /^import\b/,
  /^export\b/,
  /^http/i,
  /^\d/,
  /^[A-Z_]{3,}$/, // a CONSTANT or an env var
  /^[a-z]{1,8}$/, // a short plain word
  /^[a-z]+-[a-z]+/, // kebab-case: a file name or a CSS class
];

function isSymbol(word: string, searchesPython: boolean) {
  if (word.length < 4 || /\s/.test(word)) return false;
  if (NOT_SYMBOLS.some((notSymbol) => notSymbol.test(word))) return false;
  const isCamelCase = /^[a-z][a-zA-Z0-9]{3,}$/.test(word) && /[A-Z]/.test(word);
  const isPascalCase = /^[A-Z][a-zA-Z][a-zA-Z0-9]{2,}$/.test(word);
  // snake_case is a real symbol in Python only; in TypeScript it is a table or a column, which no LSP indexes
  const isSnakeCase = searchesPython && /^[a-z]+(_[a-z]+){2,}$/.test(word) && word.length >= 9;
  return isCamelCase || isPascalCase || isSnakeCase;
}

// The identifiers among a pattern's alternatives: `UserService|createOrder` gives both.
function symbolsOf(pattern: string, searchesPython: boolean) {
  return pattern
    .split(/\\?\||\./) // alternatives, and each side of `a.b`
    .map((word) =>
      word
        .replace(/\\[a-zA-Z]/g, " ") // an escape goes whole: `Dao\b` must not read as the PascalCase `Daob`
        .replace(/[*+?^${}()[\]\\]/g, "")
        .trim(),
    )
    .filter((word) => isSymbol(word, searchesPython));
}

// ── the verdict ──────────────────────────────────────────────────────────────

// The code symbols a shell grep looks up, which the guard refuses; none when the command is no such lookup.
export function grepSymbols(rawCommand: string): string[] {
  const command = cleanCommand(rawCommand);
  if (!SEARCH_PROGRAM.test(command)) return [];
  if (GREP_EXEMPTIONS.some((exemption) => exemption.applies(command))) return [];

  const pattern = searchPattern(command);
  if (!pattern || isRegex(pattern)) return [];

  const searchesPython = /\.py\b|--include=?\S*\.py\b|-t\s*py\b/i.test(command);
  return symbolsOf(pattern, searchesPython);
}
