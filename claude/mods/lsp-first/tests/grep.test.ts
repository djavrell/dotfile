import { expect, test } from 'claude-code/testing'

import { grepSymbols } from '../hooks/lib/grep'

test('a recursive grep on a code symbol is refused, every symbol named', () => {
  expect(grepSymbols('grep -rn "buildAgentTree" claude/mods/session/hooks/')).toEqual(['buildAgentTree'])
  expect(grepSymbols("rg 'UserService|createOrder' src/")).toEqual(['UserService', 'createOrder'])
})

test('words that are no symbols pass', () => {
  expect(grepSymbols('grep -rn "TODO" src/')).toEqual([])
  expect(grepSymbols('grep -rn "API_KEY" src/')).toEqual([])
  expect(grepSymbols('grep -rn "user-card" src/')).toEqual([])
  // snake_case is a symbol in Python only
  expect(grepSymbols('grep -rn "geo_control_synthesis" src/')).toEqual([])
  expect(grepSymbols('grep -rn "get_user_sessions" app.py lib.py')).toEqual(['get_user_sessions'])
})

test('a regex pattern passes, an escaped dot is still a name', () => {
  expect(grepSymbols('grep -rn "build.*Tree" src/')).toEqual([])
  expect(grepSymbols('grep -rn "UserService\\." src/')).toEqual(['UserService'])
})

test('exemption: git grep', () => {
  expect(grepSymbols('git grep buildAgentTree')).toEqual([])
})

test('exemption: typings', () => {
  expect(grepSymbols('grep -nE "flexShrink|borderStyle" types/claude-code/index.d.ts')).toEqual([])
})

test('exemption: -v', () => {
  expect(grepSymbols('grep -rv "DeprecationWarning" src/')).toEqual([])
})

test('exemption: a filter on a program output', () => {
  expect(grepSymbols('npm test 2>&1 | grep "FailedTest"')).toEqual([])
  // xargs makes it a search of files again
  expect(grepSymbols('find src | xargs grep "UserService"')).toEqual(['UserService'])
})

test('exemption: trees without indexed code', () => {
  expect(grepSymbols('grep -rn "UserService" node_modules/foo/')).toEqual([])
})

test('exemption: --include of non-code files', () => {
  expect(grepSymbols('grep -rn --include=*.md "UserService" .')).toEqual([])
})

test('exemption: one known file', () => {
  expect(grepSymbols('grep -n "buildAgentTree" lib/agentTree.ts')).toEqual([])
})

test('exemption: -c and context flags', () => {
  expect(grepSymbols('grep -rc "buildAgentTree" src/')).toEqual([])
  expect(grepSymbols('grep -rn -A 3 "buildAgentTree" src/')).toEqual([])
})

test('exemption: only non-code files named', () => {
  expect(grepSymbols('grep -n "UserService" notes.md todo.md')).toEqual([])
})
