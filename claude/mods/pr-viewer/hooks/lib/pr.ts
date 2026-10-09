import type { PullRequest } from "../../types";

export const PR_FIELDS = "number,title,state,isDraft,reviewDecision,statusCheckRollup";

// one entry of gh's statusCheckRollup: a GitHub Actions run, or a commit status from another CI
type RollupItem = {
  __typename?: string;
  status?: string;
  conclusion?: string;
  state?: string;
};

const FAILED = new Set([
  "FAILURE",
  "ERROR",
  "TIMED_OUT",
  "CANCELLED",
  "ACTION_REQUIRED",
  "STARTUP_FAILURE",
]);

const checkOf = (item: RollupItem): PullRequest["checks"] => {
  // a CheckRun is pending until COMPLETED, then judged by its conclusion; a StatusContext by its state
  const outcome =
    item.__typename === "StatusContext"
      ? item.state
      : item.status === "COMPLETED"
        ? item.conclusion
        : "PENDING";
  if (outcome && FAILED.has(outcome)) return "fail";
  if (outcome === "PENDING" || outcome === "EXPECTED") return "pending";
  return "pass";
};

export function rollupChecks(items: readonly RollupItem[]): PullRequest["checks"] {
  const checks = items.map(checkOf);
  if (checks.includes("fail")) return "fail";
  if (checks.includes("pending")) return "pending";
  return checks.length ? "pass" : "none";
}

const REVIEW: Record<string, PullRequest["review"]> = {
  APPROVED: "approved",
  CHANGES_REQUESTED: "changes_requested",
  REVIEW_REQUIRED: "required",
};

// `gh pr view --json PR_FIELDS` output; null when it is not one
export function parsePullRequest(json: string): PullRequest | null {
  try {
    const raw = JSON.parse(json);
    if (typeof raw?.number !== "number") return null;
    return {
      number: raw.number,
      title: String(raw.title ?? ""),
      state:
        raw.state === "MERGED"
          ? "merged"
          : raw.state === "CLOSED"
            ? "closed"
            : raw.isDraft
              ? "draft"
              : "open",
      checks: rollupChecks(Array.isArray(raw.statusCheckRollup) ? raw.statusCheckRollup : []),
      review: REVIEW[raw.reviewDecision] ?? "none",
    };
  } catch {
    return null;
  }
}
