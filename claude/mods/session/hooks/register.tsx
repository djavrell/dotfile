import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Agent, Change } from '../types'

const PANE = 'session'
const files = atom({ plugin: 'session', key: 'files' } as const, [])
const agents = atom({ plugin: 'session', key: 'agents' } as const, [])
const skills = atom({ plugin: 'session', key: 'skills' } as const, [])
const WRITERS = new Set(['Edit', 'MultiEdit', 'Write', 'NotebookEdit', 'Bash'])
const DEBOUNCE_MS = 300
// quotePath off: accented paths come out as-is instead of "caf\303\251.ts"
const GIT = ['git', '-c', 'core.quotePath=false']

const STATUS: Record<string, { icon: string; color: string }> = {
  pending: { icon: '●', color: 'yellow' },
  running: { icon: '●', color: 'yellow' },
  waiting: { icon: '●', color: 'yellow' },
  idle: { icon: '○', color: 'gray' },
  completed: { icon: '✓', color: 'green' },
  failed: { icon: '✗', color: 'red' },
  killed: { icon: '✗', color: 'red' },
}

// bumped by every refresh request: a run that is no longer the latest drops its result
let gen = 0

// `git diff --numstat` line: "<added>\t<deleted>\t<path>", "-" for binary
export const parseNumstat = (out: string): Change[] =>
  out
    .split('\n')
    .filter(Boolean)
    .map(line => {
      const [a = '', d = '', ...rest] = line.split('\t')
      return {
        path: rest.join('\t'),
        added: a === '-' ? null : Number(a),
        deleted: d === '-' ? null : Number(d),
        isNew: false,
      }
    })

export const parseUntracked = (out: string): Change[] =>
  out
    .split('\n')
    .filter(Boolean)
    .map(path => ({ path, added: null, deleted: null, isNew: true }))

async function isPaneOpen($: EngineInterface) {
  return (await $.ui.panes()).some(pane => pane.id === PANE)
}

async function refresh($: EngineInterface) {
  const my = ++gen
  // ponytail: HEAD fails in a repo without commits; untracked files still show there
  // both lists are repo-root relative and cover the whole repo, whatever the cwd
  const [diff, untracked] = await Promise.all([
    $.process.run([...GIT, 'diff', '--numstat', '--no-renames', 'HEAD']),
    $.process.run([...GIT, 'ls-files', '--others', '--exclude-standard', '--full-name', ':/']),
  ])
  if (my !== gen) return
  const next = diff.exitCode === 0 ? parseNumstat(diff.stdout) : []
  if (untracked.exitCode === 0) next.push(...parseUntracked(untracked.stdout))
  await update($, files, () => next)
}

// coalesces bursts of tool calls into one git run, and skips it while the pane is closed
async function scheduleRefresh($: EngineInterface) {
  const my = ++gen
  await $.clock.sleep(DEBOUNCE_MS)
  if (my !== gen || !(await isPaneOpen($))) return
  await refresh($)
}

// ponytail: the engine drops finished agents from its list shortly after; no history kept
async function refreshAgents($: EngineInterface) {
  const list = await $.agent.list()
  const next: Agent[] = list.map(a => ({ id: a.id, type: a.type, description: a.description, status: a.status }))
  await update($, agents, () => next)
}

async function addSkill($: EngineInterface, name: string) {
  await update($, skills, list => (list.includes(name) ? list : [...list, name]))
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({ name: 'session', description: 'Toggle the session pane: agents, skills, changed files' })
    void refresh($).catch(() => {})
    void $.ui.open({ id: PANE, title: 'Session', columns: 50 })

    return next(e)
  })

  on('command.run', { command: 'session' }, async $ => {
    if (await isPaneOpen($)) {
      await $.ui.close({ id: PANE })

      return { text: 'Session pane closed.' }
    }
    await Promise.all([refresh($), refreshAgents($)]).catch(() => {})
    await $.ui.open({ id: PANE, title: 'Session', columns: 50 })

    return { text: 'Session pane opened.' }
  })

  on('tool.call', async ($, e, next) => {
    const ran = await next(e)
    if (e.tool === 'Skill' && typeof e.skill === 'string') void addSkill($, e.skill).catch(() => {})
    if (WRITERS.has(e.tool)) void scheduleRefresh($).catch(() => {})

    return ran
  })

  on('agent.spawn', async ($, e, next) => {
    const ran = await next(e)
    void refreshAgents($).catch(() => {})

    return ran
  })

  on('turn.complete', async ($, e, next) => {
    const ran = await next(e)
    if (e.agentId) void refreshAgents($).catch(() => {})

    return ran
  })

  // skill.prompt did not fire in a live session on 2.1.291: Skill tool calls and typed
  // /name commands are caught above and here instead
  on('skill.prompt', async ($, e, next) => {
    void addSkill($, e.skill).catch(() => {})

    return next(e)
  })

  // ponytail: any user/plugin command counts as a skill, the engine does not tell them apart
  on('command.run', async ($, e, next) => {
    const ran = await next(e)
    if (e.command !== 'session') {
      const info = (await $.command.list()).find(c => c.name === e.command)
      if (info && (info.source === 'user' || info.source === 'plugin')) await addSkill($, e.command).catch(() => {})
    }

    return ran
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const list = await read($, files)
    const agentList = await read($, agents)
    const skillList = await read($, skills)
    const added = list.reduce((n, f) => n + (f.added ?? 0), 0)
    const deleted = list.reduce((n, f) => n + (f.deleted ?? 0), 0)

    return (
      <Box flexDirection="column">
        <Text bold>Agents</Text>
        {agentList.length === 0 && <Text dimColor>None.</Text>}
        {agentList.map(a => {
          const s = STATUS[a.status] ?? { icon: '?', color: 'gray' }
          return (
            <Box key={a.id} flexDirection="row" gap={1}>
              <Text color={s.color}>{s.icon}</Text>
              <Text color="cyan">{a.type}</Text>
              <Text wrap="truncate-end" dimColor>
                {a.description}
              </Text>
            </Box>
          )
        })}
        <Text> </Text>
        <Text bold>Skills</Text>
        {skillList.length === 0 && <Text dimColor>None.</Text>}
        {skillList.length > 0 && <Text wrap="wrap">{skillList.join(', ')}</Text>}
        <Text> </Text>
        <Text bold>Changes</Text>
        {list.length === 0 && <Text dimColor>No changes.</Text>}
        {list.map(f => (
          <Box key={f.path} flexDirection="row" gap={1}>
            {f.isNew && <Text color="green">new</Text>}
            {f.added === null && !f.isNew && <Text dimColor>bin</Text>}
            {f.added !== null && <Text color="green">+{f.added}</Text>}
            {f.deleted !== null && <Text color="red">-{f.deleted}</Text>}
            <Text wrap="truncate-start">{f.path}</Text>
          </Box>
        ))}
        {list.length > 0 && (
          <Text dimColor>
            {list.length} files, +{added} -{deleted}
          </Text>
        )}
      </Box>
    )
  })
}
