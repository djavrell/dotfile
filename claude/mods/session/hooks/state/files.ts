// The Files section's state: the changed files (git, debounced after writes and polled while the pane is open)
// and the folded folders. The atoms stay here with their read/update calls, as the validator requires.
import { atom, read, update } from "claude-code";
import type { EngineInterface } from "claude-code";

import {
  DIFF_ARGS,
  UNTRACKED_ARGS,
  parseNumstat,
  parseUntracked,
} from "../lib/git";
import { isPaneOpen } from "./pane";

const files = atom({ plugin: "session", key: "files" } as const, []);
const collapsedFolders = atom(
  { plugin: "session", key: "collapsedFolders" } as const,
  [],
);

const GIT_POLL_MS = 10_000;
const DEBOUNCE_MS = 300;
export const WRITERS = new Set([
  "Edit",
  "MultiEdit",
  "Write",
  "NotebookEdit",
  "Bash",
]);

// bumped by every refresh request: a run that is no longer the latest drops its result
let refreshGeneration = 0;

export async function refresh($: EngineInterface) {
  const thisGeneration = ++refreshGeneration;
  // ponytail: HEAD fails in a repo without commits; untracked files still show there
  const [diff, untracked] = await Promise.all([
    $.process.run(DIFF_ARGS),
    $.process.run(UNTRACKED_ARGS),
  ]);
  if (thisGeneration !== refreshGeneration) return;
  const changes = diff.exitCode === 0 ? parseNumstat(diff.stdout) : [];
  if (untracked.exitCode === 0)
    changes.push(...parseUntracked(untracked.stdout));
  await update($, files, () => changes);
}

// coalesces bursts of tool calls into one git run, and skips it while the pane is closed
export async function scheduleRefresh($: EngineInterface) {
  const thisGeneration = ++refreshGeneration;
  await $.clock.sleep(DEBOUNCE_MS);
  if (thisGeneration !== refreshGeneration || !(await isPaneOpen($))) return;
  await refresh($);
}

// ponytail: a folded folder stays listed once its files are committed; harmless, the list stays tiny
export async function toggleFolder($: EngineInterface, folderPath: string) {
  await update($, collapsedFolders, (folderPaths) =>
    folderPaths.includes(folderPath)
      ? folderPaths.filter((path) => path !== folderPath)
      : [...folderPaths, folderPath],
  );
}

// git changes made outside Claude (a commit, a checkout in another terminal) raise no event:
// re-read them on a timer while the pane is open
// ponytail: polling; a file watcher if git ever gets slow on a big repo
export async function gitPoller($: EngineInterface) {
  for (;;) {
    await $.clock.sleep(GIT_POLL_MS);
    if (!(await isPaneOpen($))) continue;
    await refresh($).catch(() => {});
  }
}

// the changed files and the folded folders, for the pane's render
export async function readFiles($: EngineInterface) {
  return Promise.all([read($, files), read($, collapsedFolders)]);
}
