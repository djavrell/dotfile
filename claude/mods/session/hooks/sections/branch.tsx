import type { Elements } from "claude-code";
import type { PullRequest } from "git-provider";
import type { PaletteColorPath, PaletteTheme } from "palette";

import { paint } from "../lib/theme";

const BRANCH_ICON = ""; // nf-dev-git_branch
const PR_ICON = ""; // nf-oct-git_pull_request
const MERGED_ICON = ""; // nf-oct-git_merge

type Mark = { icon: string; role: PaletteColorPath };

const STATE_ROLE: Record<PullRequest["state"], PaletteColorPath> = {
  open: "ansi.green",
  draft: "comment",
  merged: "ansi.magenta",
  closed: "ansi.red",
};
const CHECKS_MARK: Record<PullRequest["checks"], Mark | null> = {
  pass: { icon: "", role: "ansi.green" }, // nf-fa-check_circle
  fail: { icon: "", role: "ansi.red" }, // nf-fa-times_circle
  pending: { icon: "", role: "ansi.yellow" }, // nf-fa-clock_o
  none: null,
};
const REVIEW_MARK: Record<PullRequest["review"], Mark | null> = {
  approved: { icon: "", role: "ansi.green" }, // nf-fa-thumbs_up
  changes_requested: { icon: "", role: "ansi.red" }, // nf-fa-pencil
  required: { icon: "", role: "ansi.yellow" }, // nf-fa-eye
  none: null,
};

// the branch and its pull request on one line, as git-provider publishes them: branch, pull request number (linked
// to GitHub, colored by state), CI and review icons, then the title, cut first when the pane is narrow.
// Nothing outside git or on a detached HEAD without a pull request
export function BranchSection({
  ui: { Box, Text, Link },
  theme,
  branchName,
  pullRequest,
}: {
  ui: Pick<Elements[keyof Elements], "Box" | "Text" | "Link">;
  theme?: PaletteTheme;
  branchName: string | null;
  pullRequest: PullRequest | null;
}) {
  if (!branchName && !pullRequest) return null;
  const marks = pullRequest
    ? [CHECKS_MARK[pullRequest.checks], REVIEW_MARK[pullRequest.review]].filter((mark) => mark !== null)
    : [];

  return (
    <Box flexDirection="column">
      <Text weight="semibold">Branch</Text>
      <Text wrap="truncate-end">
        {branchName && (
          <Text color={paint(theme, "ansi.blue")}>
            {BRANCH_ICON} {branchName}
          </Text>
        )}
        {pullRequest && (
          <Text>
            {branchName ? "  " : ""}
            <Text color={paint(theme, STATE_ROLE[pullRequest.state])}>
              {pullRequest.state === "merged" ? MERGED_ICON : PR_ICON}{" "}
              <Link href={pullRequest.url}>#{pullRequest.number}</Link>
            </Text>
            {marks.map((mark) => (
              <Text key={mark.icon} color={paint(theme, mark.role)}>
                {" "}
                {mark.icon}
              </Text>
            ))}{" "}
            <Text dimColor>{pullRequest.title}</Text>
          </Text>
        )}
      </Text>
      <Text> </Text>
    </Box>
  );
}
