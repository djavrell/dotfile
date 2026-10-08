// countdown scaled to the window: days for 7d, bare minutes when imminent
export const fmtLeft = (seconds: number) => {
  if (seconds >= 86400)
    return `${Math.floor(seconds / 86400)}d${Math.floor((seconds % 86400) / 3600)}h`;
  if (seconds >= 3600)
    return `${Math.floor(seconds / 3600)}h${String(Math.floor((seconds % 3600) / 60)).padStart(2, "0")}m`;
  return `${Math.floor(seconds / 60)}m`;
};

export const fmtElapsed = (seconds: number) =>
  seconds >= 3600
    ? `${Math.floor(seconds / 3600)}h${String(Math.floor((seconds % 3600) / 60)).padStart(2, "0")}m`
    : `${Math.floor(seconds / 60)}m${String(seconds % 60).padStart(2, "0")}s`;

// 950, 123k, 1M, 1.5M
export const fmtTokens = (tokenCount: number) =>
  tokenCount < 1000
    ? String(tokenCount)
    : tokenCount < 1e6
      ? `${Math.round(tokenCount / 1000)}k`
      : `${(tokenCount / 1e6).toFixed(1).replace(/\.0$/, "")}M`;
