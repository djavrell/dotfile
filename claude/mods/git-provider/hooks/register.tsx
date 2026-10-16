// The current branch's pull request: fetched with gh, published as the `current` and `branch` states.
// Drawing belongs to the consumers (the session pane's Branch section).
// The atoms stay in this file with their read/update calls (the validator wants them together); parsing lives in lib/pr.ts.
import { atom, update } from "claude-code";
import type { EngineInterface, Register, Timer } from "claude-code";

import { PR_FIELDS, parsePullRequest } from "./lib/pr";

const current = atom({ plugin: "git-provider", key: "current" } as const, null);
const branch = atom({ plugin: "git-provider", key: "branch" } as const, null);

// ponytail: polls GitHub once a minute; a webhook-fed source if the delay ever matters
const PR_POLL_MS = 60_000;
// `refs/heads/feature/x` -> `feature/x`
const LOCAL_BRANCH_PREFIX = /^refs\/heads\//;
// gh's answer for a branch without a pull request; any other failure (network, rate limit, auth) keeps the last value
const NO_PULL_REQUEST = /no pull requests found/i;
// the tools that can move HEAD: a checkout goes through Bash, a worktree move through EnterWorktree/ExitWorktree
const SWITCHING_TOOLS = new Set(["Bash", "EnterWorktree", "ExitWorktree"]);

// the branch checked out (its ref name, empty when detached), to refetch as soon as it changes;
// undefined until the first look, so a detached HEAD at start still fetches
let lastHead: string | undefined;
// the minute poll, cancelled when a new session.start starts another
let pollTimer: Timer | undefined;
// bumped by every fetch: a run that is no longer the latest drops its result
let fetchGeneration = 0;

async function fetchPullRequest($: EngineInterface) {
  const thisGeneration = ++fetchGeneration;
  const view = await $.process.run(["gh", "pr", "view", "--json", PR_FIELDS]);
  if (thisGeneration !== fetchGeneration) return;
  if (view.exitCode === 0) {
    await update($, current, () => parsePullRequest(view.stdout));
  } else if (NO_PULL_REQUEST.test(view.stderr)) {
    await update($, current, () => null);
  }
}

// true when the branch changed (and its pull request was refetched)
async function refetchOnSwitch($: EngineInterface) {
  const head = await $.process.run([
    "git",
    "--no-optional-locks",
    "symbolic-ref",
    "-q",
    "HEAD",
  ]);
  const headName = head.stdout.trim();
  if (headName === lastHead) return false;
  lastHead = headName;
  // the old branch's pull request goes first, so the new branch is never drawn beside it while gh answers;
  // the bump drops a fetch still running for the old branch
  fetchGeneration++;
  await update($, current, () => null);
  // detached HEAD or outside git: empty, hence null
  await update(
    $,
    branch,
    () => headName.replace(LOCAL_BRANCH_PREFIX, "") || null,
  );
  await fetchPullRequest($);

  return true;
}

// the minute poll: a checkout made outside Claude (another terminal) shows up here, else the pull request is refreshed
async function poll($: EngineInterface) {
  if (!(await refetchOnSwitch($))) await fetchPullRequest($);
}

export const register: Register = (on) => {
  on("session.start", async ($, event, next) => {
    void refetchOnSwitch($).catch(() => {});
    pollTimer?.cancel();
    pollTimer = $.clock.every(
      PR_POLL_MS,
      () => void poll($).catch(() => {}),
    );

    return next(event);
  });

  // refetchOnSwitch only fetches when the ref name changed
  on("tool.call", async ($, event, next) => {
    const result = await next(event);
    if (SWITCHING_TOOLS.has(event.tool))
      void refetchOnSwitch($).catch(() => {});

    return result;
  });

  // /cd moves the session's directory, where git and gh run
  on("command.run", { command: "cd" }, async ($, event, next) => {
    const result = await next(event);
    void refetchOnSwitch($).catch(() => {});

    return result;
  });
};
