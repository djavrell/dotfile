import type { Change } from "../../types";
import { EDITED_MARK, FOLDER_ICON, READ_MARK, fileIcon } from "../lib/icons";
import type { Colors, Ui } from "../lib/theme";
import { buildTree } from "../lib/tree";

// one tree for edited and read files: `change` set on edited ones, absent on read ones
type FileEntry = { path: string; change?: Change };

export function FilesSection({
  ui: { Box, Text },
  color,
  changedFiles,
  readPaths,
}: {
  ui: Ui;
  color: Colors;
  changedFiles: readonly Change[];
  // shown paths of the files read, edited ones included
  readPaths: readonly string[];
}) {
  const changedPaths = new Set(changedFiles.map((file) => file.path));
  // a file read then edited counts as edited
  const readOnly = readPaths.filter((path) => !changedPaths.has(path));
  const fileEntries: FileEntry[] = [
    ...changedFiles.map((change) => ({ path: change.path, change })),
    ...readOnly.map((path) => ({ path })),
  ];
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
      {fileEntries.length === 0 && <Text dimColor>None.</Text>}
      {buildTree(fileEntries).map((row, rowIndex) => {
        const change = row.item?.change;
        const icon = row.item ? fileIcon(row.label) : undefined;
        return (
          <Box key={`file-${rowIndex}`} flexDirection="row" gap={1}>
            <Text wrap="truncate-end">
              <Text dimColor>{row.branch}</Text>
              {icon ? (
                <Text color={color[icon.color]}>{icon.glyph} </Text>
              ) : (
                <Text color={color.yellow}>{FOLDER_ICON} </Text>
              )}
              {!row.item ? (
                <Text color={color.blue}>{row.label}</Text>
              ) : change ? (
                row.label
              ) : (
                <Text dimColor>{row.label}</Text>
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
            {row.item && !change && (
              <Text color={color.blue}>{READ_MARK}</Text>
            )}
          </Box>
        );
      })}
      {fileEntries.length > 0 && (
        <Text dimColor>
          {changedFiles.length} edited, {readOnly.length} read · +{addedTotal} -
          {deletedTotal}
        </Text>
      )}
    </Box>
  );
}
