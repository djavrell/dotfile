// A `cd <dir> && cmd` prefix makes every command unique, so no permission allow rule ever matches it.
import { cleanCommand, isScratchOrToolingPath, listSegments, maskQuotes } from './command';

// `cd <path>` then `&&` or `;` and a command, read on the quote-masked command (a quoted path is blanked,
// hence `[^;&|\n]+?` rather than `\S+`). A lone `cd dir`, or `cd dir ||`, does not match.
const LEADING_CD = /^cd\s+[^;&|\n]+?\s*(?:&&|;)\s*\S/;
const CD_WORD = /^cd\s+/;
const QUOTES_AROUND = /^['"]|['"]$/g;

// The directory a command's leading `cd <dir> &&|;` moves to; null when there is none or it is scratch space
// (the trailing slash lets a bare `.../scratchpad` match).
export function leadingCdTarget(rawCommand: string): string | null {
  const command = cleanCommand(rawCommand);
  if (!LEADING_CD.test(maskQuotes(command))) return null;
  const target = listSegments(command)[0]!.replace(CD_WORD, '').replace(QUOTES_AROUND, '');
  return isScratchOrToolingPath(`${target}/`) ? null : target;
}
