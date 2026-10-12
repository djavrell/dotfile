import { expect, test } from 'claude-code/testing'

test("a cclsp cold start is primed and run again, the retry's result answered", async ($, on) => {
  const mcpCalls: string[] = []
  // beneath the plugin: cclsp's tool answers its cold start
  on('tool.call', { tool: /^mcp__cclsp__/ }, () => ({ result: 'No Project.', text: 'No Project.' }))
  on('mcp.call', (_hookApi, event) => {
    mcpCalls.push(event.tool)
    return { value: { content: [{ type: 'text', text: 'src/a.ts:3' }], isError: false } }
  })

  const answer = await $.tool.call({ tool: 'mcp__cclsp__find_references', file_path: 'src/a.ts', symbol_name: 'UserService' })

  expect(mcpCalls).toEqual(['get_diagnostics', 'find_references'])
  expect(answer.result).toEqual([{ type: 'text', text: 'src/a.ts:3' }])
})

test('a shell grep on a code symbol is refused', async ($) => {
  const answer = await $.tool.call({ tool: 'Bash', command: 'rg -n "UserService" src/' })

  expect(answer.deny).toMatch(/^LSP-FIRST: grep on code symbol\(s\) UserService/)
})
