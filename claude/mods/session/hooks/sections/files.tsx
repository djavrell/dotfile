import type { Change } from "../../types";
import { EDITED_MARK, FOLDER_ICON, fileIcon } from "../lib/icons";
import type { Colors, Ui } from "../lib/theme";
import { buildTree } from "../lib/tree";

export function FilesSection({
  ui: { Box, Text },
  color,
  changedFiles,
}: {
  ui: Ui;
  color: Colors;
  changedFiles: readonly Change[];
}) {
  const addedTotal = changedFiles.reduce(
    (total, file) => total + (file.added ?? 0),
    0,
  );
  const deletedTotal = changedFiles.reduce(
    (total, file) => total + (file.deleted ?? 0),
    0,
  );

  return (
    <Box flexDirection="column">
      <Text bold>Files</Text>
      {changedFiles.length === 0 && <Text dimColor>None.</Text>}
      {buildTree(changedFiles).map((row, rowIndex) => {
        const change = row.item;
        const icon = change ? fileIcon(row.label) : undefined;
        return (
          <Box key={`file-${rowIndex}`} flexDirection="row" gap={1}>
            <Text wrap="truncate-end">
              <Text dimColor>{row.branch}</Text>
              {icon ? (
                <Text color={color[icon.color]}>{icon.glyph} </Text>
              ) : (
                <Text color={color.yellow}>{FOLDER_ICON} </Text>
              )}
              {change ? (
                row.label
              ) : (
                <Text color={color.blue}>{row.label}</Text>
              )}
            </Text>
            {change && change.added !== null && (
              <Text color={color.green}>+{change.added}</Text>
            )}
            {change && change.deleted !== null && change.deleted > 0 && (
              <Text color={color.red}>-{change.deleted}</Text>
            )}
            {change && change.added === null && !change.isNew && (
              <Text dimColor>bin</Text>
            )}
            {change && (
              <Text color={change.isNew ? color.green : color.yellow}>
                {EDITED_MARK}
              </Text>
            )}
          </Box>
        );
      })}
      {changedFiles.length > 0 && (
        <Text dimColor>
          {changedFiles.length} edited · +{addedTotal} -{deletedTotal}
        </Text>
      )}
    </Box>
  );
}
