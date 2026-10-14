// The current branch's pull request: fetched with gh, published as the `current` state, drawn as one line in
// the band above the prompt. No pull request (or no gh), no band.
// The atoms stay in this file with their read/update calls (the validator wants them together); parsing lives in lib/pr.ts.
import { atom, read, update } from "claude-code";
import type { EngineInterface, Register, Timer } from "claude-code";

import type { PullRequest } from "../types";
import { PR_FIELDS, parsePullRequest } from "./lib/pr";

const current = atom({ plugin: "pr-viewer", key: "current" } as const, null);
const branch = atom({ plugin: "pr-viewer", key: "branch" } as const, null);

// ponytail: polls GitHub once a minute; a webhook-fed source if the delay ever matters
const PR_POLL_MS = 60_000;
// `refs/heads/feature/x` -> `feature/x`
const LOCAL_BRANCH_PREFIX = /^refs\/heads\//;
const BRANCH_ICON = ""; // nf-dev-git_branch
const PR_ICON = ""; // nf-oct-git_pull_request
const MERGED_ICON = ""; // nf-oct-git_merge

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
  const pullRequest =
    view.exitCode === 0 ? parsePullRequest(view.stdout) : null;
  await update($, current, () => pullRequest);
}

async function refetchOnSwitch($: EngineInterface) {
  const head = await $.process.run([
    "git",
    "--no-optional-locks",
    "symbolic-ref",
    "-q",
    "HEAD",
  ]);
  const headName = head.stdout.trim();
  if (headName === lastHead) return;
  lastHead = headName;
  // detached HEAD or outside git: empty, hence null
  await update(
    $,
    branch,
    () => headName.replace(LOCAL_BRANCH_PREFIX, "") || null,
  );
  await fetchPullRequest($);
}

// $.palette is absent for a moment when this mod draws before palette has loaded: default colors then
async function getTheme($: EngineInterface) {
  try {
    return await $.palette.get();
  } catch {
    return undefined;
  }
}

export const register: Register = (on) => {
  on("session.start", async ($, event, next) => {
    void refetchOnSwitch($).catch(() => {});
    pollTimer?.cancel();
    pollTimer = $.clock.every(
      PR_POLL_MS,
      () => void fetchPullRequest($).catch(() => {}),
    );

    return next(event);
  });

  // a checkout goes through Bash, a worktree move through EnterWorktree/ExitWorktree: any tool may switch
  // branches, and refetchOnSwitch only fetches when the ref name changed
  on("tool.call", async ($, event, next) => {
    const result = await next(event);
    void refetchOnSwitch($).catch(() => {});

    return result;
  });

  // /cd moves the session's directory, where git and gh run
  on("command.run", { command: "cd" }, async ($, event, next) => {
    const result = await next(event);
    void refetchOnSwitch($).catch(() => {});

    return result;
  });

  on("ui.render", { component: "AbovePrompt" }, async ($, event, next) => {
    // a survey holds the band first
    if (event.props.hasSurvey) return next(event);
    const [pullRequest, branchName, theme] = await Promise.all([
      read($, current),
      read($, branch),
      getTheme($),
    ]);
    if (!pullRequest && !branchName) return next(event);
    const { Box, Text, Link } = $.ui.resolve(event);
    const ansi = theme?.ansi;
    // no pull request: the branch alone, in a muted blue so a pull request line still stands out
    if (!pullRequest) {
      return (
        <Box width={event.props.bodyColumns}>
          <Text wrap="truncate-end" color={ansi?.blue}>
            {BRANCH_ICON} {branchName}
          </Text>
        </Box>
      );
    }
    const stateColor: Record<PullRequest["state"], string | undefined> = {
      open: ansi?.green,
      draft: theme?.comment,
      merged: ansi?.magenta,
      closed: ansi?.red,
    };

    const checks = {
      pass: { mark: "✓ CI", color: ansi?.green },
      fail: { mark: "✗ CI", color: ansi?.red },
      pending: { mark: "● CI", color: ansi?.yellow },
      none: null,
    }[pullRequest.checks];

    const review = {
      approved: { mark: "✓ approved", color: ansi?.green },
      changes_requested: { mark: "✗ changes requested", color: ansi?.red },
      required: { mark: "○ review required", color: ansi?.yellow },
      none: null,
    }[pullRequest.review];

    return (
      <Box flexDirection="row" width={event.props.bodyColumns} columnGap={2}>
        <Box flexShrink={1}>
          <Text wrap="truncate-end">
            <Text color={stateColor[pullRequest.state]}>
              {pullRequest.state === "merged" ? MERGED_ICON : PR_ICON}{" "}
              <Link href={pullRequest.url}>#{pullRequest.number}</Link>
              {pullRequest.state === "open" ? "" : ` ${pullRequest.state}`}
            </Text>{" "}
            {pullRequest.title}
          </Text>
        </Box>
        {checks && (
          <Box flexShrink={0}>
            <Text color={checks.color}>{checks.mark}</Text>
          </Box>
        )}
        {review && (
          <Box flexShrink={0}>
            <Text color={review.color}>{review.mark}</Text>
          </Box>
        )}
      </Box>
    );
  });
};
