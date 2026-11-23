import { expect, test } from 'claude-code/testing';

import { grepSymbols } from '../hooks/lib/grep';

test('a recursive grep on a code symbol is refused, every symbol named', () => {
  expect(grepSymbols('grep -rn "buildAgentTree" claude/mods/session/hooks/')).toEqual(['buildAgentTree']);
  expect(grepSymbols("rg 'UserService|createOrder' src/")).toEqual(['UserService', 'createOrder']);
});

test('words that are no symbols pass', () => {
  expect(grepSymbols('grep -rn "TODO" src/')).toEqual([]);
  expect(grepSymbols('grep -rn "API_KEY" src/')).toEqual([]);
  expect(grepSymbols('grep -rn "user-card" src/')).toEqual([]);
  // snake_case is a symbol in Python only
  expect(grepSymbols('grep -rn "geo_control_synthesis" src/')).toEqual([]);
  expect(grepSymbols('grep -rn "get_user_sessions" app.py lib.py')).toEqual(['get_user_sessions']);
});

test('a regex pattern passes, an escaped dot is still a name', () => {
  expect(grepSymbols('grep -rn "build.*Tree" src/')).toEqual([]);
  expect(grepSymbols('grep -rn "UserService\\." src/')).toEqual(['UserService']);
});

test('exemption: git grep', () => {
  expect(grepSymbols('git grep buildAgentTree')).toEqual([]);
});

test('exemption: typings', () => {
  expect(grepSymbols('grep -nE "flexShrink|borderStyle" types/claude-code/index.d.ts')).toEqual([]);
});

test('exemption: -v', () => {
  expect(grepSymbols('grep -rv "DeprecationWarning" src/')).toEqual([]);
});

test('exemption: a filter on a program output', () => {
  expect(grepSymbols('npm test 2>&1 | grep "FailedTest"')).toEqual([]);
  // xargs makes it a search of files again
  expect(grepSymbols('find src | xargs grep "UserService"')).toEqual(['UserService']);
});

test('exemption: trees without indexed code', () => {
  expect(grepSymbols('grep -rn "UserService" node_modules/foo/')).toEqual([]);
});

test('exemption: --include of non-code files', () => {
  expect(grepSymbols('grep -rn --include=*.md "UserService" .')).toEqual([]);
});

test('exemption: one known file', () => {
  expect(grepSymbols('grep -n "buildAgentTree" lib/agentTree.ts')).toEqual([]);
});

test('exemption: -c and context flags', () => {
  expect(grepSymbols('grep -rc "buildAgentTree" src/')).toEqual([]);
  expect(grepSymbols('grep -rn -A 3 "buildAgentTree" src/')).toEqual([]);
});

test('exemption: only non-code files named', () => {
  expect(grepSymbols('grep -n "UserService" notes.md todo.md')).toEqual([]);
});

test('a grep after a pipe filters output, whatever the program and what comes before', () => {
  expect(grepSymbols('cargo test 2>&1 | grep "UnexpectedToken"')).toEqual([]);
  expect(grepSymbols('cd /x; pacman -Si neovim | grep Version')).toEqual([]);
  // a quoted pipe is no pipe
  expect(grepSymbols('grep -rn "Foo|UserService" src/')).toEqual(['UserService']);
});

test('each list segment is judged on its own', () => {
  expect(grepSymbols('cd /home/me/repo; grep -rn "UserService" src/')).toEqual(['UserService']);
  expect(grepSymbols('npm run build && grep -rn "UserService" src/ | head')).toEqual(['UserService']);
});

test('a one-letter class is the letter: the disguise is still a symbol', () => {
  expect(grepSymbols('grep -rn "Invalid[V]alue" src/')).toEqual(['InvalidValue']);
  expect(grepSymbols('grep -rn "Invalid[VW]alue" src/')).toEqual([]);
});

test('exemption: named files and globs, Lua included', () => {
  expect(grepSymbols('grep -n "setupKeymaps" lua/plugins/keys.lua')).toEqual([]);
  expect(grepSymbols('grep -n "toContain\\|expectError" tests/*.ts')).toEqual([]);
});

test('exemption: third-party trees', () => {
  expect(grepSymbols('grep -rn "setupKeymaps" ~/.local/share/nvim/lazy/')).toEqual([]);
  expect(grepSymbols('rg "ParseError" ~/.cargo/registry/src')).toEqual([]);
});

test('a grep quoted in a heredoc body is payload, not a search', () => {
  const prBody = 'gh pr create --body "$(cat <<\'EOF\'\nRan grep -rn "UserService" src/ to check.\nEOF\n)"';
  expect(grepSymbols(prBody)).toEqual([]);
});
