// Shell commands that read a source file: `cat`, `head`, `tail` or `sed -n` given the file as an argument.
// Read with offset/limit shows the same window, numbered, and registers the file for a later Edit; in two Dolmen
// sessions `cd src && sed -n '120,180p' x.ts` came 64 and 21 times despite a rule asking for Read.
// Ported from the read half of the classic hook bash-file-read-block.js.
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

// The LSP's source files, plus the code no LSP here indexes but Read shows just as well.
const READ_SOURCE_PATH = new RegExp(String.raw`(?:${SOURCE_EXTENSION}|\.(?:sql|lua|zsh|sh))${EXTENSION_END}$`, 'i');
// Typings are allowed, as the grep guard allows them.
const TYPINGS_PATH = /\.d\.ts$/i;

const isProjectSourceFile = (path: string) =>
  READ_SOURCE_PATH.test(path) && !TYPINGS_PATH.test(path) && !isScratchOrToolingPath(path);

// `cat`, `head`, `tail`, and `sed` only with -n, alone or grouped (`-ne`, `-En`): a sed filter is no window read,
// and `sed -i` is refused by the write guard before this one runs.
const READING_PROGRAM = /^(?:cat|head|tail)\b|^sed(?=.*\s(?:-[a-zA-Z]*n[a-zA-Z]*|--quiet|--silent)(?:\s|$))/;
// `> out.txt`, `2>&1`, `>> log`: a redirect's target is written, not read (`cat > a.ts <<EOF` is the write guard's).
const OUTPUT_REDIRECT = /\d*>>?&?\s*\S+/g;

// The source files a reading part names as arguments; at the receiving end of a pipe it names none and reads stdin.
function readFiles(part: string) {
  if (!READING_PROGRAM.test(part)) return [];
  return part
    .replace(OUTPUT_REDIRECT, ' ')
    .split(/\s+/)
    .slice(1)
    .map((argument) => argument.replace(/^['"<]+|['"]+$/g, ''))
    .filter((argument) => READ_SOURCE_PATH.test(argument));
}

// The first project source file a shell command reads, which the guard refuses; null when it reads none.
// A relative path is judged after the command's own `cd` (`cd /tmp/x && cat a.ts` reads scratch).
// ponytail: the shell's persisted cwd stays unknown, as in lib/write.ts
export function shellReadTarget(rawCommand: string): string | null {
  let directory = '';
  for (const part of commandParts(withoutHeredocBodies(cleanCommand(rawCommand)))) {
    const cdTarget = part.match(CD_TARGET)?.[1];
    if (cdTarget) directory = joinPath(directory, cdTarget);
    const readSourceFile = readFiles(part)
      .map((path) => joinPath(directory, path))
      .find(isProjectSourceFile);
    if (readSourceFile) return readSourceFile;
  }
  return null;
}
