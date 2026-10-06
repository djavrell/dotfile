import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { PaletteTheme } from 'palette'

import type { Agent, Change, ModelInfo } from '../types'

const PANE = 'session'
const files = atom({ plugin: 'session', key: 'files' } as const, [])
const agents = atom({ plugin: 'session', key: 'agents' } as const, [])
const skills = atom({ plugin: 'session', key: 'skills' } as const, [])
const info = atom({ plugin: 'session', key: 'info' } as const, null)
const branch = atom({ plugin: 'session', key: 'branch' } as const, '')
// bumped on a timer and after each turn so usage, countdown and elapsed time redraw
const tick = atom({ plugin: 'session', key: 'tick' } as const, 0)
const compactAt = atom({ plugin: 'session', key: 'compactAt' } as const, null)
// share of the auto-compaction threshold past which the context line warns
const COMPACT_WARN = 0.9
const TICK_MS = 30_000
const MIN_BAR = 4
const MAX_BAR = 16
// the colors this pane paints with, from the terminal theme the palette mod shares
const colors = (p: PaletteTheme) => ({ ...p.ansi, yellowBright: p.brights.yellow, gray: p.comment })
type Role = keyof ReturnType<typeof colors>
const EFFORT_COLOR: Record<string, Role> = { max: 'magenta', xhigh: 'magenta', high: 'cyan' }

// thresholds of statusline-command.sh: green < 50 <= yellow < 80 <= red
const band = (pct: number): Role => (pct >= 80 ? 'red' : pct >= 50 ? 'yellow' : 'green')

// countdown scaled to the window: days for 7d, bare minutes when imminent
const fmtLeft = (secs: number) => {
  if (secs >= 86400) return `${Math.floor(secs / 86400)}d${Math.floor((secs % 86400) / 3600)}h`
  if (secs >= 3600) return `${Math.floor(secs / 3600)}h${String(Math.floor((secs % 3600) / 60)).padStart(2, '0')}m`
  return `${Math.floor(secs / 60)}m`
}

// 950, 123k, 1M, 1.5M
export const fmtTokens = (n: number) =>
  n < 1000 ? String(n) : n < 1e6 ? `${Math.round(n / 1000)}k` : `${(n / 1e6).toFixed(1).replace(/\.0$/, '')}M`

const fmtElapsed = (secs: number) =>
  secs >= 3600
    ? `${Math.floor(secs / 3600)}h${String(Math.floor((secs % 3600) / 60)).padStart(2, '0')}m`
    : `${Math.floor(secs / 60)}m${String(secs % 60).padStart(2, '0')}s`
const WRITERS = new Set(['Edit', 'MultiEdit', 'Write', 'NotebookEdit', 'Bash'])
const DEBOUNCE_MS = 300
// quotePath off: accented paths come out as-is instead of "caf\303\251.ts"
const GIT = ['git', '-c', 'core.quotePath=false']

const STATUS: Record<string, { icon: string; color: Role }> = {
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

async function refreshBranch($: EngineInterface) {
  const ref = await $.process.run(['git', '--no-optional-locks', 'symbolic-ref', '--short', 'HEAD'])
  if (ref.exitCode === 0) return update($, branch, () => ref.stdout.trim())
  // detached HEAD: show the commit instead
  const sha = await $.process.run(['git', '--no-optional-locks', 'rev-parse', '--short', 'HEAD'])
  await update($, branch, () => (sha.exitCode === 0 ? `@${sha.stdout.trim()}` : ''))
}

async function ticker($: EngineInterface) {
  for (;;) {
    await $.clock.sleep(TICK_MS)
    await update($, tick, n => n + 1)
  }
}

// the summary breakdown is estimated locally: no API call
async function refreshCompactAt($: EngineInterface) {
  const { context } = await $.session.usage({ breakdown: 'summary' })
  await update($, compactAt, () => context.breakdown?.autoCompactThreshold ?? null)
}

// $.palette is absent for a moment when this mod draws before palette has loaded: default colors then
async function getTheme($: EngineInterface) {
  try {
    return await $.palette.get()
  } catch {
    return undefined
  }
}

async function addSkill($: EngineInterface, name: string) {
  await update($, skills, list => (list.includes(name) ? list : [...list, name]))
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({ name: 'session', description: 'Toggle the session pane: agents, skills, changed files' })
    void refresh($).catch(() => {})
    void refreshBranch($).catch(() => {})
    void refreshCompactAt($).catch(() => {})
    void ticker($).catch(() => {})
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
    // a checkout/switch goes through Bash
    if (e.tool === 'Bash') void refreshBranch($).catch(() => {})

    return ran
  })

  on('turn.step', async function* ($, e, next) {
    if (!e.agentId) {
      const now: ModelInfo = {
        model: e.model.replace(/^claude-/, ''),
        effort: e.effort === undefined ? undefined : String(e.effort),
      }
      void update($, info, () => now).catch(() => {})
    }

    return yield* next(e)
  })

  on('agent.spawn', async ($, e, next) => {
    const ran = await next(e)
    void refreshAgents($).catch(() => {})

    return ran
  })

  on('turn.complete', async ($, e, next) => {
    const ran = await next(e)
    if (e.agentId) void refreshAgents($).catch(() => {})
    else {
      void update($, tick, n => n + 1).catch(() => {})
      // the threshold moves with the model (/model) and the settings
      void refreshCompactAt($).catch(() => {})
    }

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

    await read($, tick)
    const [m, br, usage, now, theme, compactTokens] = await Promise.all([
      read($, info),
      read($, branch),
      $.session.usage(),
      $.clock.now(),
      getTheme($),
      read($, compactAt),
    ])
    const C: Partial<Record<Role, string>> = theme ? colors(theme) : {}
    const pct = usage.context.percent ?? 0
    const h5 = usage.rateLimits.find(r => r.kind === 'five_hour')
    const d7 = usage.rateLimits.find(r => r.kind === 'seven_day')
    const spend = usage.rateLimits.find(r => r.kind === 'spend_limit')
    // one countdown, for the 7d window once it is under pressure, else the 5h one
    const binding = d7 && h5 && d7.percentUsed > h5.percentUsed && d7.percentUsed >= 50 ? d7 : h5
    const left = binding?.resetsAt ? Math.floor((Date.parse(binding.resetsAt) - now) / 1000) : 0
    const elapsed = Math.floor((now - usage.startedAt) / 1000)
    const tokens = usage.context.tokens
    // close to the auto-compaction threshold, which can sit well below the model's window
    const nearCompact = !!tokens && !!compactTokens && tokens >= compactTokens * COMPACT_WARN
    // the bar takes what the line leaves after "[", "] ", the percentage and the token count, up to MAX_BAR
    const ctxTail =
      ` ${Math.round(pct)}%  📊 ${tokens ? `${fmtTokens(tokens)}/${fmtTokens(usage.context.window)}` : '--/--'}` +
      (nearCompact ? ' ⚠' : '')
    const barLen = Math.max(MIN_BAR, Math.min(MAX_BAR, e.props.bodyColumns - 2 - ctxTail.length))
    const fill = Math.min(barLen, Math.max(0, Math.round((pct * barLen) / 100)))

    // docked, fill the pane's height so the grown top block pushes Status to the bottom
    const minHeight = e.props.placement === 'dock' ? e.props.scroll.bodyRows : undefined

    return (
      <Box flexDirection="column" minHeight={minHeight}>
        <Box flexDirection="column" flexGrow={1}>
          <Text bold>Agents</Text>
          {agentList.length === 0 && <Text dimColor>None.</Text>}
          {agentList.map(a => {
            const s = STATUS[a.status] ?? { icon: '?', color: 'gray' }
            return (
              <Box key={a.id} flexDirection="row" gap={1}>
                <Text color={C[s.color]}>{s.icon}</Text>
                <Text color={C.cyan}>{a.type}</Text>
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
              {f.isNew && <Text color={C.green}>new</Text>}
              {f.added === null && !f.isNew && <Text dimColor>bin</Text>}
              {f.added !== null && <Text color={C.green}>+{f.added}</Text>}
              {f.deleted !== null && <Text color={C.red}>-{f.deleted}</Text>}
              <Text wrap="truncate-start">{f.path}</Text>
            </Box>
          ))}
          {list.length > 0 && (
            <Text dimColor>
              {list.length} files, +{added} -{deleted}
            </Text>
          )}
          <Text> </Text>
        </Box>
        <Text bold>Status</Text>
        <Box flexDirection="row" gap={2}>
          <Text color={C.cyan}>🤖 {m?.model ?? 'Claude'}</Text>
          {m?.effort && (
            <Text color={C[EFFORT_COLOR[m.effort] ?? 'white']} dimColor={!EFFORT_COLOR[m.effort]}>
              🧠 {m.effort}
            </Text>
          )}
          {usage.cost && usage.cost.usd > 0 && <Text color={C.red}>💰 ${usage.cost.usd.toFixed(4)}</Text>}
        </Box>
        <Box flexDirection="row" gap={2}>
          {br && <Text color={br.startsWith('@') ? C.yellow : C.green}>⎇ {br.replace(/^@/, '')}</Text>}
          {h5 && d7 && (
            <Text>
              <Text color={C.yellow}>⚡ </Text>
              <Text color={C[band(h5.percentUsed)]}>{Math.round(h5.percentUsed)}%</Text>
              <Text dimColor>/</Text>
              <Text color={C[band(d7.percentUsed)]}>{Math.round(d7.percentUsed)}%</Text>
              {left > 0 && <Text color={C.blue}> ↺ {fmtLeft(left)}</Text>}
            </Text>
          )}
          {spend && <Text color={C[band(spend.percentUsed)]}>💳 {Math.round(spend.percentUsed)}%</Text>}
          {elapsed > 0 && <Text color={C.magenta}>⏱ {fmtElapsed(elapsed)}</Text>}
        </Box>
        <Text color={nearCompact ? C.red : C.yellow} wrap="truncate-end">
          [<Text color={nearCompact ? C.red : C.yellowBright}>{'█'.repeat(fill)}</Text>
          {'░'.repeat(barLen - fill)}]{ctxTail}
        </Text>
      </Box>
    )
  })
}
