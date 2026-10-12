type TextBlock = { type?: unknown; text?: unknown };

const blocksText = (blocks: unknown[]) =>
  blocks
    .map((block) => (block && typeof (block as TextBlock).text === "string" ? (block as TextBlock).text : ""))
    .filter(Boolean)
    .join("\n");

// The text a tool result shows, from the shapes seen so far: a string, Bash's { stdout, stderr },
// an Agent's { content: [{ text }] } or a bare block list. Empty when the shape is unknown: not folded.
export function resultText(output: unknown): string {
  if (typeof output === "string") return output;
  if (Array.isArray(output)) return blocksText(output);
  if (!output || typeof output !== "object") return "";
  const record = output as Record<string, unknown>;
  if (Array.isArray(record.content)) return blocksText(record.content);
  return [record.stdout, record.stderr].filter((part) => typeof part === "string" && part !== "").join("\n");
}

// The harness frames a subagent's hand-back in a paragraph that ends with this, then indents the report under it.
const HAND_BACK_FRAME_END = "The report follows:";

// A message's own words: a subagent's report without the harness frame around it, any other text as it is.
export function reportBody(text: string): string {
  const frameEnd = text.indexOf(HAND_BACK_FRAME_END);
  if (frameEnd === -1) return text;
  return text
    .slice(frameEnd + HAND_BACK_FRAME_END.length)
    .split("\n")
    .map((line) => line.replace(/^ {2}/, ""))
    .join("\n")
    .replace(/^\n+/, "");
}

// The one line a result folds to, or null when it has no text: nothing to fold.
export function foldSummary(text: string): string | null {
  if (text.trim() === "") return null;
  const lines = text.replace(/\n+$/, "").split("\n");
  const firstLine = lines.find((line) => line.trim() !== "")?.trim() ?? "";
  return `${lines.length} ligne${lines.length > 1 ? "s" : ""} · ${firstLine}`;
}
