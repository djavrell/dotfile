// Shell commands that write a project file: text authored in the command (`cat > f <<EOF`, `echo >>`, `printf >`),
// tee, an in-place sed or perl, or a script's own write call. Edit and Write show the change as a diff and fail
// loudly on a missing anchor; a heredoc or a script's write_text() does neither. Those forms are refused for any
// file of the project, Markdown or a zsh file without extension included: when only source files were guarded,
// sessions moved every edit to the other files, and a refused sed came back as `python3 - <<EOF`.
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
} from './command';

const SOURCE_PATH = new RegExp(`${SOURCE_EXTENSION}${EXTENSION_END}`, 'i');
// devices (`> /dev/null`) and scratch space are no project file
const isProjectFile = (path: string) => !/^\/dev\//.test(path) && !isScratchOrToolingPath(path);

// ── the writes ───────────────────────────────────────────────────────────────

// A written path: anything up to a space, a quote or a shell operator.
const PATH = String.raw`([^\s'"|;&<>()]+)`;
// `> notes.md`, `>> src/app.ts`, `> "a b.md"`; not `2>&1`, whose target is a descriptor
const REDIRECT_TARGET = new RegExp(String.raw`(?<![&\d])>>?\s*['"]?${PATH}`);
const REDIRECT_FROM_ORIGINAL = /^>>?\s*(?:"([^"]+)"|'([^']+)')/;
// Text quoted in the command is no redirect (`echo "a > b"`), unless it is the redirect's own target.
const QUOTED_NOT_TARGET = /(?<!>\s*)("(?:\\.|[^"\\])*"|'[^']*')/g;
const blankQuotes = (part: string) => part.replace(QUOTED_NOT_TARGET, (quoted) => ' '.repeat(quoted.length));

// Programs whose redirect writes text the command itself authors: that is an edit, whatever the file.
// Another program's output sent to a file (`eslint > report.txt`) is a log, refused only onto a source file.
const AUTHORING_PROGRAM = /^(?:cat|echo|printf)\b/i;
// `sed -i`, `sed -Ei`, `perl -pi -e`
const IN_PLACE_EDIT = /^(?:sed|perl)\b(?=.*\s-[a-zA-Z]*i)/;

// The files a command part writes through the shell itself, each with whether any file counts or source only.
function shellWrittenFiles(part: string): { path: string; anyFile: boolean }[] {
  const unquoted = blankQuotes(part);
  if (/^tee\b/i.test(unquoted)) {
    const teeFiles = unquoted.split(/\s+/).slice(1).filter((argument) => argument && !argument.startsWith('-'));
    return teeFiles.map((path) => ({ path, anyFile: true }));
  }
  if (IN_PLACE_EDIT.test(unquoted)) {
    // the quoted script is blanked out: what is left after the options are the files
    const editedFiles = unquoted.split(/\s+/).slice(1).filter((argument) => argument && !argument.startsWith('-'));
    return editedFiles.map((path) => ({ path, anyFile: true }));
  }
  const redirect = unquoted.match(REDIRECT_TARGET);
  if (!redirect) return [];
  // a quoted target may hold spaces: read it back from the original, at the same place
  const original = part.slice(redirect.index).match(REDIRECT_FROM_ORIGINAL);
  const target = original?.[1] ?? original?.[2] ?? redirect[1]!;
  return [{ path: target, anyFile: AUTHORING_PROGRAM.test(unquoted) }];
}

// A script's write call: Python's `Path("a.md").write_text(...)` and `open("a.md", "w")`, Node's
// `writeFileSync("a.md", ...)`, by the path literal it names or the variable it holds.
const LITERAL_WRITE_CALLS = [
  /\bPath\(\s*['"]([^'"]+)['"]\s*\)\s*\.write_text\s*\(/g,
  /\bopen\s*\(\s*['"]([^'"]+)['"]\s*,\s*['"][wa]\+?['"]/g,
  /\bwriteFileSync\s*\(\s*['"]([^'"]+)['"]/g,
];
// `target = Path('src/a.rs')` then `target.write_text(...)`: the form refused seds came back as
const VARIABLE_WRITE_CALLS = [
  /\b(\w+)\.write_text\s*\(/g,
  /\bopen\s*\(\s*(\w+)\s*,\s*['"][wa]\+?['"]/g,
  /\bwriteFileSync\s*\(\s*(\w+)\s*,/g,
];
const PATH_ASSIGNMENT = /\b(\w+)\s*=\s*(?:Path\(\s*)?['"]([^'"]+)['"]/g;

// ponytail: a path built at run time (a loop, sys.argv, an f-string) goes unseen; resolve more if that ever matters
function scriptWrittenFiles(command: string) {
  const assignedPaths = new Map([...command.matchAll(PATH_ASSIGNMENT)].map((match) => [match[1]!, match[2]!]));
  const literalPaths = LITERAL_WRITE_CALLS.flatMap((writeCall) => [...command.matchAll(writeCall)].map((match) => match[1]!));
  const variablePaths = VARIABLE_WRITE_CALLS.flatMap((writeCall) =>
    [...command.matchAll(writeCall)].flatMap((match) => assignedPaths.get(match[1]!) ?? []),
  );
  return [...literalPaths, ...variablePaths];
}

// ── where a path lands ───────────────────────────────────────────────────────

// A part that only sets a shell variable (`variant=/tmp/x`); a `cd` is lib/command.ts's CD_TARGET.
const ASSIGNMENT = /^(\w+)=['"]?([^'"\s]*)['"]?$/;
const VARIABLE = /\$\{?(\w+)\}?/g;

// ── the verdict ──────────────────────────────────────────────────────────────

// The project file a shell command writes, which the guard refuses; null when it writes none.
// Each path is judged where it lands: after the command's own `cd`, with the variables it set expanded.
// ponytail: the shell's persisted cwd and loop variables stay unknown; only a cd or assignment in the command counts
export function shellWriteTarget(rawCommand: string): string | null {
  const command = cleanCommand(rawCommand);
  const variables = new Map<string, string>();
  let directory = '';
  const candidates: string[] = [];
  for (const rawPart of commandParts(withoutHeredocBodies(command))) {
    const part = rawPart.replace(VARIABLE, (whole, name: string) => variables.get(name) ?? whole);
    const assignment = part.match(ASSIGNMENT);
    if (assignment) variables.set(assignment[1]!, assignment[2]!);
    const cdTarget = part.match(CD_TARGET)?.[1];
    if (cdTarget) directory = joinPath(directory, cdTarget);
    for (const { path, anyFile } of shellWrittenFiles(part)) {
      if (!anyFile && !SOURCE_PATH.test(path)) continue;
      // behind an unknown variable (`$loop/a.md`) the path may be anywhere: judged as written, never moved under the cd
      candidates.push(path.startsWith('$') ? path : joinPath(directory, path));
    }
  }
  // the script's code sits in the heredoc body: its write calls are looked for in the whole command
  candidates.push(...scriptWrittenFiles(command).map((path) => joinPath(directory, path)));
  return candidates.find(isProjectFile) ?? null;
}
