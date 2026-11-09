// Shell commands that write a source file: a redirect, tee, sed -i, or a script's own write call. Edit and Write
// show the change as a diff and fail loudly on a missing anchor; a heredoc or a script's write_text() does neither.
// Ported from the write half of the classic hook bash-file-read-block.js; its read half is lib/read.ts.
import {
  CD_TARGET,
  EXTENSION_END,
  SOURCE_EXTENSION,
  cleanCommand,
  commandParts,
  isScratchOrToolingPath,
  joinPath,
  withoutHeredocBodies,
} from "./command";

const SOURCE_PATH = new RegExp(`${SOURCE_EXTENSION}${EXTENSION_END}`, "i");
const isProjectSourceFile = (path: string) => SOURCE_PATH.test(path) && !isScratchOrToolingPath(path);

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

// ── where a path lands ───────────────────────────────────────────────────────

// A part that only sets a shell variable (`variant=/tmp/x`); a `cd` is lib/command.ts's CD_TARGET.
const ASSIGNMENT = /^(\w+)=['"]?([^'"\s]*)['"]?$/;
const VARIABLE = /\$\{?(\w+)\}?/g;

// ── the verdict ──────────────────────────────────────────────────────────────

// The project source file a shell command writes, which the guard refuses; null when it writes none.
// Each path is judged where it lands: after the command's own `cd`, with the variables it set expanded.
// ponytail: the shell's persisted cwd and loop variables stay unknown; only a cd or assignment in the command counts
export function shellWriteTarget(rawCommand: string): string | null {
  const command = cleanCommand(rawCommand);
  const variables = new Map<string, string>();
  let directory = "";
  const candidates: string[] = [];
  for (const rawPart of commandParts(withoutHeredocBodies(command))) {
    const part = rawPart.replace(VARIABLE, (whole, name: string) => variables.get(name) ?? whole);
    const assignment = part.match(ASSIGNMENT);
    if (assignment) variables.set(assignment[1]!, assignment[2]!);
    const cdTarget = part.match(CD_TARGET)?.[1];
    if (cdTarget) directory = joinPath(directory, cdTarget);
    const written = shellWrittenFile(part);
    // behind an unknown variable (`$loop/a.ts`) the path may be anywhere: judged as written, never moved under the cd
    if (written) candidates.push(part.includes(`$${written}`) ? written : joinPath(directory, written));
  }
  // the script's code sits in the heredoc body: its write calls are looked for in the whole command
  candidates.push(...scriptWrittenFiles(command).map((path) => joinPath(directory, path)));
  return candidates.find(isProjectSourceFile) ?? null;
}
