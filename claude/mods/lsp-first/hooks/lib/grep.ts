// Shell greps that look up a code symbol. An LSP lookup answers those better (the exact definition, the real
// references), so the guard refuses them and names the LSP call to make instead.
// Ported from the classic hook bash-grep-block.js.
import { cleanCommand, listSegments, maskQuotes, withoutHeredocBodies } from './command';

const SEARCH_PROGRAM = /\b(grep|rg|ag|ack)\b/i;

// ── exemptions ───────────────────────────────────────────────────────────────
// A grep that is no symbol lookup, or one no LSP call can answer, runs untouched. Each is judged on one
// list segment (`a; b && c`), so a `cd x;` or a build before the grep changes nothing.

type Exemption = { reason: string; applies: (segment: string) => boolean };

// `cargo test | grep Expected`, `pacman -Si x | grep Version`: a grep after a pipe filters a program's
// output, whatever the program; only xargs or -exec make it read files again.
function readsPipe(segment: string) {
  const unquoted = maskQuotes(segment);
  const pipeIndex = unquoted.indexOf('|');
  const grepComesAfterPipe = pipeIndex !== -1 && pipeIndex < unquoted.search(SEARCH_PROGRAM);
  return grepComesAfterPipe && !/\bxargs\b|-exec\b/.test(unquoted);
}

const RECURSIVE_FLAG = /\s-\w*[rR]\w*\b|--recursive|--include/i;
// a named file or a glob of them (`tests/*.ts`), in a language cclsp serves or another
const SOURCE_FILE_ARGUMENT =
  /(?:^|\s)['"]?[\w./@~*-]+\.(?:ts|tsx|js|jsx|mjs|cjs|py|go|rs|lua|java|kt|swift|vue|svelte)['"]?(?=\s|$|\||;)/gi;

// `grep -n "UserService" user.service.ts tests/*.ts`: "where in these files" is cheaper by grep than by any
// LSP call. rg recurses by default, so only grep counts.
function searchesNamedFiles(segment: string) {
  if (RECURSIVE_FLAG.test(segment) || !/\bgrep\b/.test(segment)) return false;
  return (segment.match(SOURCE_FILE_ARGUMENT) ?? []).length > 0;
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
const NON_CODE_FILE = /\.(sql|md|json|yaml|yml|txt|env|sh|css|scss|log|toml|xml|csv)\b/i;

// `grep -r "UserService" docs/notes.md`: only non-code files are named, and nothing points at code.
function searchesOnlyNonCodeFiles(segment: string) {
  const pointsAtCode = CODE_SEARCH_HINTS.some((hint) => hint.test(segment));
  return NON_CODE_FILE.test(segment) && !pointsAtCode;
}

// Trees no LSP of the project indexes: generated or vendored code, other tools' caches and plugins.
const UNINDEXED_TREE =
  /(?:^|[\s'"/\\])(?:supabase[/\\]migrations|\.task|\.claude|node_modules|knowledge-vault|\.cargo|\.rustup|\.cache|\.local[/\\]share|site-packages|vendor)(?:[/\\]|$)/i;

const GREP_EXEMPTIONS: Exemption[] = [
  {
    reason: 'git grep: a deliberate search of the git index',
    applies: (segment) => /\bgit\s+grep\b/i.test(segment),
  },
  {
    reason: "typings (.d.ts): no LSP index holds their members (csstype's flexShrink), grep is the only way in",
    applies: (segment) => /\.d\.ts\b/.test(segment),
  },
  {
    reason: '-v drops lines: nobody looks for a definition by excluding it',
    applies: (segment) => /\b(?:grep|rg|ag|ack)\s+(?:-\w*v\w*|--invert-match)\b/i.test(segment),
  },
  {
    reason: "a filter on another program's output, not a search of files",
    applies: readsPipe,
  },
  {
    reason: 'a tree that holds no indexed code (node_modules, cargo registry, nvim plugins, .claude, notes)',
    // the tree name starts an argument (after a space or a quote) or a path segment (after a slash)
    applies: (segment) => UNINDEXED_TREE.test(segment),
  },
  {
    reason: '--include of non-code files only',
    applies: (segment) => /--include=?\S*\.(sql|md|json|yaml|yml|txt|env|sh|css|scss|log|csv)\b/i.test(segment),
  },
  {
    reason: 'named files: grep finds the line cheaper than any LSP call',
    applies: searchesNamedFiles,
  },
  {
    reason: '-c counts occurrences: LSP has no count',
    applies: (segment) => /\b(?:grep|rg|ag|ack)\s+(?:-\w*c\w*|--count)\b/i.test(segment),
  },
  {
    reason: '-A/-B/-C asks for the lines around: LSP answers positions only',
    applies: (segment) => /\s-[ABC]\s?\d|--(?:after|before)-context\b|--context\b/i.test(segment),
  },
  {
    reason: 'only non-code files are searched',
    applies: searchesOnlyNonCodeFiles,
  },
];

// ── the pattern and its symbols ──────────────────────────────────────────────

// The searched pattern: double-quoted, single-quoted, or a bare PascalCase word.
function searchPattern(segment: string) {
  const unescaped = segment.replace(/\\"/g, '"');
  const doubleQuoted = unescaped.match(/\b(?:grep|rg|ag|ack)\s+(?:-\S+\s+)*"([^"]+)"/i);
  const singleQuoted = unescaped.match(/\b(?:grep|rg|ag|ack)\s+(?:-\S+\s+)*'([^']+)'/i);
  const bareWord = unescaped.match(/\b(?:grep|rg|ag|ack)\s+(?:(?:-\w+\s+(?:[a-z]+\s+)?)*?)([A-Z][a-zA-Z]\w+)/i);
  return (doubleQuoted ?? singleQuoted ?? bareWord)?.[1];
}

// `Invalid[V]alue` is `InvalidValue` in disguise: a one-letter class matches that letter only, so it goes
// before the regex test below, or the disguise would pass as a regex.
const SINGLE_LETTER_CLASS = /\[(\w)\]/g;

// `build.*Tree`, `Optional?`: an unescaped wildcard or quantifier makes a regex, and LSP looks up exact names only.
// An escaped dot (`UserService\.`) is still a name; `\\` pairs are dropped first so `\\.` reads as an escape.
const isRegex = (pattern: string) => /(?<!\\)[.?*+[]/.test(pattern.replace(/\\\\/g, ''));

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
        .replace(/\\[a-zA-Z]/g, ' ') // an escape goes whole: `Dao\b` must not read as the PascalCase `Daob`
        .replace(/[*+?^${}()[\]\\]/g, '')
        .trim(),
    )
    .filter((word) => isSymbol(word, searchesPython));
}

// ── the verdict ──────────────────────────────────────────────────────────────

// The code symbols one list segment's grep looks up; none when it is no such lookup.
function segmentSymbols(segment: string): string[] {
  if (!SEARCH_PROGRAM.test(segment)) return [];
  if (GREP_EXEMPTIONS.some((exemption) => exemption.applies(segment))) return [];

  const pattern = searchPattern(segment)?.replace(SINGLE_LETTER_CLASS, '$1');
  if (!pattern || isRegex(pattern)) return [];

  const searchesPython = /\.py\b|--include=?\S*\.py\b|-t\s*py\b/i.test(segment);
  return symbolsOf(pattern, searchesPython);
}

// The code symbols a shell command's greps look up, which the guard refuses; none when it makes no such lookup.
export function grepSymbols(rawCommand: string): string[] {
  const command = withoutHeredocBodies(cleanCommand(rawCommand));
  return [...new Set(listSegments(command).flatMap(segmentSymbols))];
}
