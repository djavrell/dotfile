// The current branch's pull request: fetched with gh, published as the `current` state, drawn as one line in
// the band above the prompt. No pull request (or no gh), no band.
// $ and the atom stay in this file (the validator does not follow them across an import); parsing lives in lib/pr.ts.
import { atom, read, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import type { PullRequest } from "../types";
import { PR_FIELDS, parsePullRequest } from "./lib/pr";

const current = atom({ plugin: "pr-viewer", key: "current" } as const, null);

// ponytail: polls GitHub once a minute; a webhook-fed source if the delay ever matters
const PR_POLL_MS = 60_000;
const PR_ICON = ""; // nf-oct-git_pull_request
const MERGED_ICON = ""; // nf-oct-git_merge

// the commit checked out, to refetch as soon as a Bash call switched branches
let lastHead = "";
// bumped by every fetch: a run that is no longer the latest drops its result
let fetchGeneration = 0;

async function fetchPullRequest($: EngineInterface) {
  const thisGeneration = ++fetchGeneration;
  const view = await $.process.run(["gh", "pr", "view", "--json", PR_FIELDS]);
  if (thisGeneration !== fetchGeneration) return;
  const pullRequest = view.exitCode === 0 ? parsePullRequest(view.stdout) : null;
  await update($, current, () => pullRequest);
}

async function refetchOnSwitch($: EngineInterface) {
  const head = await $.process.run(["git", "--no-optional-locks", "symbolic-ref", "-q", "HEAD"]);
  const headName = head.stdout.trim();
  if (headName === lastHead) return;
  lastHead = headName;
  await fetchPullRequest($);
}

async function poller($: EngineInterface) {
  for (;;) {
    await $.clock.sleep(PR_POLL_MS);
    await fetchPullRequest($).catch(() => {});
  }
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
    void poller($).catch(() => {});

    return next(event);
  });

  // a checkout or a switch goes through Bash
  on("tool.call", async ($, event, next) => {
    const result = await next(event);
    if (event.tool === "Bash") void refetchOnSwitch($).catch(() => {});

    return result;
  });

  on("ui.render", { component: "AbovePrompt" }, async ($, event, next) => {
    // a survey holds the band first
    if (event.props.hasSurvey) return next(event);
    const [pullRequest, theme] = await Promise.all([read($, current), getTheme($)]);
    if (!pullRequest) return next(event);
    const { Box, Text } = $.ui.resolve(event);
    const ansi = theme?.ansi;
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
              {pullRequest.state === "merged" ? MERGED_ICON : PR_ICON} #{pullRequest.number}
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
