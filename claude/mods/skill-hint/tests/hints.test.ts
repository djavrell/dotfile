import { expect, test } from 'claude-code/testing';

import { CHANGELOG_HINT, DOTFILES_HINT, MODS_HINT, PR_REPLY_HINT, skillHints } from '../hooks/lib/hints';

test('a mods path or the word mod asks for the mods skill, not the dotfiles one', () => {
  expect(skillHints('corrige claude/mods/session/hooks/register.tsx')).toEqual([MODS_HINT]);
  expect(skillHints('crée un mod dans ~/.bashrc.d')).toEqual([MODS_HINT]);
});

test('the word mode is no mod', () => {
  expect(skillHints('passe en mode plan')).toEqual([]);
});

test('PR comments, in French or English', () => {
  expect(skillHints('réponds aux commentaires de la PR')).toEqual([PR_REPLY_HINT]);
  expect(skillHints('address the review comments')).toEqual([PR_REPLY_HINT]);
});

test('changelog, and Claude Code news', () => {
  expect(skillHints('quoi de neuf dans le changelog ?')).toEqual([CHANGELOG_HINT]);
  expect(skillHints('les nouveautés de Claude Code')).toEqual([CHANGELOG_HINT]);
  expect(skillHints('les nouveautés du sprint')).toEqual([]);
});

test('dotfiles', () => {
  expect(skillHints('ajoute un alias dans mes dotfiles')).toEqual([DOTFILES_HINT]);
  expect(skillHints('lance dots link')).toEqual([DOTFILES_HINT]);
});

test('a slash command or an unrelated prompt gets nothing', () => {
  expect(skillHints('/mods corrige le pane')).toEqual([]);
  expect(skillHints('explique cette fonction')).toEqual([]);
});
