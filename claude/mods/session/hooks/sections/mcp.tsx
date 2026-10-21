import type { McpServer, McpStatus } from "mcp-status";
import type { PaletteColorPath, PaletteTheme } from "palette";

import { paint } from "../lib/theme";
import type { Ui } from "../lib/theme";

// gray: not called yet; green: answered; yellow: a call errored or it needs sign-in; red: down
const STATUS_COLOR: Record<McpStatus, PaletteColorPath> = {
  idle: "comment",
  ok: "ansi.green",
  warning: "ansi.yellow",
  error: "ansi.red",
};

// one line per server, the dot in its status color; a server in trouble shows its latest issue (or the
// health check's words) dimmed after its name, /mcp-health has the rest
export function McpSection({
  ui: { Box, Text },
  theme,
  serverList,
}: {
  ui: Ui;
  theme: PaletteTheme | undefined;
  serverList: readonly McpServer[];
}) {
  return (
    <Box flexDirection="column">
      <Text weight="semibold">MCP</Text>
      {serverList.length === 0 ? (
        <Text dimColor>None.</Text>
      ) : (
        serverList.map((server) => {
          const isTroubled =
            server.status === "warning" || server.status === "error";
          const detail = server.issues.at(-1) ?? server.health;
          return (
            <Text key={server.key} wrap="truncate-end">
              <Text color={paint(theme, STATUS_COLOR[server.status])}>● </Text>
              {server.name}
              {isTroubled && detail ? <Text dimColor> {detail}</Text> : null}
            </Text>
          );
        })
      )}
    </Box>
  );
}
