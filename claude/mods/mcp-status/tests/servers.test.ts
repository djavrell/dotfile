import { expect, test } from 'claude-code/testing'

import { callOutcome, formatHealth, mergeHealth, parseMcpList, recordCall, serverKeyOfTool } from '../hooks/lib/servers'

const LISTING = [
  '⚠ claude.ai connectors are disabled because ANTHROPIC_API_KEY is set',
  'Checking MCP server health…',
  '',
  'plugin:playwright:playwright: npx @playwright/mcp@latest - ✔ Connected',
  'cclsp: cclsp  - ✗ Failed to connect',
  'linear: https://mcp.linear.app/sse (SSE) - ⚠ Needs authentication',
].join('\n')

test('parses servers, their marks and the warning lines', () => {
  const { servers, notes } = parseMcpList(LISTING)
  expect(servers).toEqual([
    { name: 'plugin:playwright:playwright', key: 'plugin_playwright_playwright', health: 'Connected', status: 'ok' },
    { name: 'cclsp', key: 'cclsp', health: 'Failed to connect', status: 'error' },
    { name: 'linear', key: 'linear', health: 'Needs authentication', status: 'warning' },
  ])
  expect(notes).toEqual(['claude.ai connectors are disabled because ANTHROPIC_API_KEY is set'])
})

test('a healthy server is idle until called, ok once called', () => {
  const listed = parseMcpList(LISTING).servers
  const first = mergeHealth([], listed)
  expect(first[0]?.status).toBe('idle')
  const called = recordCall(first, 'plugin_playwright_playwright', { status: 'ok' })
  expect(mergeHealth(called, listed)[0]?.status).toBe('ok')
})

test('a server seen only through its calls joins, and stays after a check', () => {
  const servers = recordCall([], 'claude_ai_Asana', { status: 'warning', issue: 'search: bad query' })
  expect(servers).toEqual([{ name: 'claude_ai_Asana', key: 'claude_ai_Asana', status: 'warning', health: null, issues: ['search: bad query'] }])
  expect(mergeHealth(servers, []).map((server) => server.key)).toEqual(['claude_ai_Asana'])
})

test('a call: denied says nothing, an error is yellow, a server down is red', () => {
  expect(callOutcome('mcp__cclsp__find_definition', { deny: 'no' })).toBeNull()
  expect(callOutcome('mcp__cclsp__find_definition', { text: 'ok' })).toEqual({ status: 'ok' })
  expect(callOutcome('mcp__cclsp__find_definition', { isError: true, text: 'No symbol found\nmore' })).toEqual({
    status: 'warning',
    issue: 'find_definition: No symbol found',
  })
  expect(callOutcome('mcp__cclsp__find_definition', { isError: true, text: 'MCP error -32000: Connection closed' })?.status).toBe('error')
})

test('issues keep the last five', () => {
  let servers = recordCall([], 'cclsp', { status: 'warning', issue: 'e0' })
  for (const index of [1, 2, 3, 4, 5]) servers = recordCall(servers, 'cclsp', { status: 'warning', issue: `e${index}` })
  expect(servers[0]?.issues).toEqual(['e1', 'e2', 'e3', 'e4', 'e5'])
})

test('server keys from tool names, and the report', () => {
  expect(serverKeyOfTool('mcp__plugin_playwright_playwright__browser_click')).toBe('plugin_playwright_playwright')
  expect(serverKeyOfTool('Bash')).toBeUndefined()
  const servers = recordCall([], 'cclsp', { status: 'warning', issue: 'find_definition: No symbol' })
  expect(formatHealth(servers, ['a note'])).toBe('warning cclsp\n          find_definition: No symbol\n⚠ a note')
  expect(formatHealth([], [])).toBe('No MCP server.')
})
