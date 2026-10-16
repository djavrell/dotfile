// The current branch's pull request as this mod publishes it. Consumers list "git-provider" under
// `dependencies` in their plugin.json, import this type from "git-provider", and read it with
//   read($, atom({ plugin: "git-provider", key: "current" } as const, null))
export type PullRequest = {
  number: number
  title: string
  // the pull request's page on GitHub
  url: string
  // open, draft, merged, closed
  state: 'open' | 'draft' | 'merged' | 'closed'
  // the checks rolled up: one failing fails all, one running keeps it pending; none when it has no checks
  checks: 'pass' | 'fail' | 'pending' | 'none'
  // GitHub's reviewDecision; none when the repo asks for no review
  review: 'approved' | 'changes_requested' | 'required' | 'none'
}

declare module 'claude-code' {
  interface PluginState {
    'git-provider': {
      // null when the branch has no pull request, or gh cannot tell (not installed, logged out, not GitHub)
      current: PullRequest | null
      // the checked-out branch's name; null when HEAD is detached or outside git
      branch: string | null
    }
  }
}
