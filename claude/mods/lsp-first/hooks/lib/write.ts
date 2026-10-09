// Shell commands that write a source file: a redirect, tee, sed -i, or a script's own write call. Edit and Write
// show the change as a diff and fail loudly on a missing anchor; a heredoc or a script's write_text() does neither.
// Ported from the write half of the classic hook bash-file-read-block.js. Its read half (`cat`/`sed -n` on a source
// file) is dropped on purpose: auto mode asks for those commands.
import { EXTENSION_END, SOURCE_EXTENSION, cleanCommand } from "./command";

// Where a write is no edit of the project: scratch space, VCS internals, build output.
const SCRATCH_OR_TOOLING_PATH =
  /(?:^|[/\\])(?:\.claude|\.git|\.task|coverage|\.next|\.turbo|knowledge-vault|node_modules[/\\]\.bin)(?:[/\\]|$)|(?:^|[/\\])(?:scratchpad|tmp|temp)[/\\]|^\/tmp[/\\]/i;

const SOURCE_PATH = new RegExp(`${SOURCE_EXTENSION}${EXTENSION_END}`, "i");
const isProjectSourceFile = (path: string) => SOURCE_PATH.test(path) && !SCRATCH_OR_TOOLING_PATH.test(path);

// ── splitting the command ────────────────────────────────────────────────────

// A heredoc's body is payload, not command: the TypeScript inside `cat > a.ts <<'TS'` would otherwise read as
// redirects (`=>`) and source paths (`import "./x.ts"`). The body goes, its header line stays.
function withoutHeredocBodies(command: string) {
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

// The pipeline and list parts (`a | b; c && d`), split outside quotes only, each without its leading
// `VAR=value` assignments and sudo/command wrappers, so each is judged by the program it runs.
function commandParts(command: string) {
  const parts: string[] = [];
  let currentPart = "";
  let openQuote: string | null = null;
  for (let index = 0; index < command.length; index++) {
    const character = command[index]!;
    const isEscaped = command[index - 1] === "\\";
    if (openQuote) {
      if (character === openQuote && !isEscaped) openQuote = null;
      currentPart += character;
    } else if (character === '"' || character === "'") {
      openQuote = character;
      currentPart += character;
    } else if ("|;\n&".includes(character)) {
      parts.push(currentPart);
      currentPart = "";
    } else {
      currentPart += character;
    }
  }
  parts.push(currentPart);
  return parts
    .map((part) => part.trim().replace(/^(?:\w+=\S*\s+)*(?:sudo\s+|command\s+)?/, "").trim())
    .filter(Boolean);
}

// ── the writes ───────────────────────────────────────────────────────────────

// `> src/app.ts`, `>> src/app.ts`
const REDIRECT_TARGET = new RegExp(String.raw`>>?\s*['"]?([\w./@~-]+${SOURCE_EXTENSION})${EXTENSION_END}`, "i");
// `| tee src/app.ts`
const TEE_TARGET = new RegExp(String.raw`\btee\b[^|]*?['"]?([\w./@~-]+${SOURCE_EXTENSION})${EXTENSION_END}`, "i");
// any source path among a command's arguments, for `sed -i`
const SOURCE_ARGUMENT = new RegExp(String.raw`[\w./@~-]+${SOURCE_EXTENSION}${EXTENSION_END}`, "i");

// The source file a command part writes through the shell itself: a redirect, tee, or an in-place sed.
function shellWrittenFile(part: string) {
  const redirected = (part.match(REDIRECT_TARGET) ?? part.match(TEE_TARGET))?.[1];
  if (redirected) return redirected;
  const isInPlaceSed = /^sed\b/i.test(part) && /\s-i\b/.test(part);
  return isInPlaceSed ? part.match(SOURCE_ARGUMENT)?.[0] : undefined;
}

// A script's write call, by the path literal it names: Python's `Path("a.ts").write_text(...)` and
// `open("a.ts", "w")`, Node's `writeFileSync("a.ts", ...)`. Only that path counts, so a script that writes
// a .json while merely mentioning a .ts is left alone.
// ponytail: a path held in a variable (`open(target, "w")`) goes unseen; resolve the assignment if that ever matters
const SCRIPT_WRITE_CALLS = [
  /\bPath\(\s*['"]([^'"]+)['"]\s*\)\s*\.write_text\s*\(/g,
  /\bopen\s*\(\s*['"]([^'"]+)['"]\s*,\s*['"][wa]\+?['"]/g,
  /\bwriteFileSync\s*\(\s*['"]([^'"]+)['"]/g,
];

function scriptWrittenFiles(command: string) {
  return SCRIPT_WRITE_CALLS.flatMap((writeCall) => [...command.matchAll(writeCall)].map((match) => match[1]!));
}

// ── the verdict ──────────────────────────────────────────────────────────────

// The project source file a shell command writes, which the guard refuses; null when it writes none.
export function shellWriteTarget(rawCommand: string): string | null {
  const command = cleanCommand(rawCommand);
  const shellWrites = commandParts(withoutHeredocBodies(command)).map(shellWrittenFile);
  // the script's code sits in the heredoc body: its write calls are looked for in the whole command
  const candidates = [...shellWrites, ...scriptWrittenFiles(command)];
  return candidates.find((path): path is string => !!path && isProjectSourceFile(path)) ?? null;
}
