import type { Change } from "../../types";

// quotePath off: accented paths come out as-is instead of "caf\303\251.ts"
export const GIT = ["git", "-c", "core.quotePath=false"];

// both lists are repo-root relative and cover the whole repo, whatever the cwd
export const DIFF_ARGS = [...GIT, "diff", "--numstat", "--no-renames", "HEAD"];
export const UNTRACKED_ARGS = [
  ...GIT,
  "ls-files",
  "--others",
  "--exclude-standard",
  "--full-name",
  ":/",
];

// `git diff --numstat` line: "<added>\t<deleted>\t<path>", "-" for binary
export const parseNumstat = (gitOutput: string): Change[] =>
  gitOutput
    .split("\n")
    .filter(Boolean)
    .map((line) => {
      const [addedField = "", deletedField = "", ...pathParts] = line.split("\t");
      return {
        path: pathParts.join("\t"),
        added: addedField === "-" ? null : Number(addedField),
        deleted: deletedField === "-" ? null : Number(deletedField),
        isNew: false,
      };
    });

export const parseUntracked = (gitOutput: string): Change[] =>
  gitOutput
    .split("\n")
    .filter(Boolean)
    .map((path) => ({ path, added: null, deleted: null, isNew: true }));
