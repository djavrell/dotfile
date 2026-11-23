// the user forgets to load skills by hand: each trigger names the skill or command its kind of prompt needs
const MODS_PATH = /claude\/mods\//;
const MODS_WORD = /\bmods?\b/i;
const COMMENT_WORD = /\bcomment(aire)?s?\b/i;
const PR_WORD = /\bPRs?\b/i;
const REVIEW_COMMENTS = /\breview comments?\b/i;
const CHANGELOG_WORD = /\bchangelog\b/i;
// "nouveautés" alone is too broad: only Claude Code's; no closing \b, `é` is no word character for it
const NEWS_WORD = /\bnouveaut/i;
const CLAUDE_WORD = /\bclaude\b/i;
const DOTFILES_WORDS = /~\/\.bashrc\.d|\bdotfiles?\b|\bdots link\b|\bzsh module\b|\bmodule zsh\b/i;

export const MODS_HINT =
  'Load the `mods` skill before touching claude/mods/ (Edit there fails in auto mode; the skill\'s workflow avoids it).';
export const PR_REPLY_HINT = 'If the `/pr-reply` command exists, suggest it.';
export const CHANGELOG_HINT = 'Use the `changelog` skill.';
export const DOTFILES_HINT = 'Load the `dotfiles` skill.';

// ponytail: keyword regexes, no config; a skill's description could drive this if the list grows past a handful
export function skillHints(prompt: string): string[] {
  if (prompt.trimStart().startsWith('/')) return [];
  const hints: string[] = [];
  const aboutMods = MODS_PATH.test(prompt) || MODS_WORD.test(prompt);
  if (aboutMods) hints.push(MODS_HINT);
  if (REVIEW_COMMENTS.test(prompt) || (COMMENT_WORD.test(prompt) && PR_WORD.test(prompt))) hints.push(PR_REPLY_HINT);
  if (CHANGELOG_WORD.test(prompt) || (NEWS_WORD.test(prompt) && CLAUDE_WORD.test(prompt))) hints.push(CHANGELOG_HINT);
  // the mods live inside the dotfiles: the `mods` skill wins there
  if (!aboutMods && DOTFILES_WORDS.test(prompt)) hints.push(DOTFILES_HINT);
  return hints;
}
