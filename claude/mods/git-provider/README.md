# git-provider

Publishes the checked-out branch and its GitHub pull request (number, title, state, CI status, review status) as state, for other
mods to draw: the `session` pane shows them in its Branch section. It refetches on a branch switch (checkout, worktree, `/cd`) and
polls GitHub each minute. It draws nothing itself, and only reads the pull request, never changes it.

Requires `gh` installed and logged in (`gh auth login`).

## Example

A consumer lists `git-provider` under `dependencies` in its `plugin.json`, then reads:

```tsx
const pullRequest = await read($, atom({ plugin: "git-provider", key: "current" } as const, null));
const branchName = await read($, atom({ plugin: "git-provider", key: "branch" } as const, null));
```
