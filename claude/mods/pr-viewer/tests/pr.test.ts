import { expect, test } from 'claude-code/testing'

import { parsePullRequest, rollupChecks } from '../hooks/lib/pr'

const run = (status: string, conclusion = '') => ({ __typename: 'CheckRun', status, conclusion })
const commitStatus = (state: string) => ({ __typename: 'StatusContext', state })

test('one failing check fails all, one running keeps it pending', () => {
  expect(rollupChecks([run('COMPLETED', 'SUCCESS'), run('COMPLETED', 'SKIPPED')])).toBe('pass')
  expect(rollupChecks([run('COMPLETED', 'SUCCESS'), run('IN_PROGRESS'), commitStatus('ERROR')])).toBe('fail')
  expect(rollupChecks([run('QUEUED'), commitStatus('SUCCESS')])).toBe('pending')
  expect(rollupChecks([])).toBe('none')
})

test('reads gh pr view output', () => {
  const json = JSON.stringify({
    number: 42, title: 'Add the band', state: 'OPEN', isDraft: true, reviewDecision: 'CHANGES_REQUESTED',
    statusCheckRollup: [run('COMPLETED', 'SUCCESS')],
  })
  expect(parsePullRequest(json)).toEqual({
    number: 42, title: 'Add the band', state: 'draft', checks: 'pass', review: 'changes_requested',
  })
  expect(parsePullRequest('{"number":1,"state":"MERGED","reviewDecision":""}')?.state).toBe('merged')
  expect(parsePullRequest('no pull requests found')).toBe(null)
})
