import type { Elements } from "claude-code";
import type { PaletteTheme } from "palette";

import type { Change } from "../../types";
import { EDITED_MARK, FOLDER_CLOSED_ICON, FOLDER_ICON, fileIcon } from "../lib/icons";
import { paint, unInverted as unInvertedIn } from "../lib/theme";
import type { Ui } from "../lib/theme";
import { buildTree } from "../lib/tree";

export function FilesSection({
  ui: { Box, Button, Text },
  theme,
  changedFiles,
  collapsedFolders,
  onToggleFolder,
}: {
  // the folder lines are buttons: this section needs Button on top of Box and Text
  ui: Ui & Pick<Elements[keyof Elements], "Button">;
  theme?: PaletteTheme;
  changedFiles: readonly Change[];
  collapsedFolders: ReadonlySet<string>;
  onToggleFolder: (folderPath: string) => void;
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
      <Text weight="semibold">Files</Text>
      {changedFiles.length === 0 && <Text dimColor>None.</Text>}
      {buildTree(changedFiles, collapsedFolders).map((row, rowIndex) => {
        const { folderPath } = row;
        // a click on a folder's line folds and unfolds its children; `hover` keeps the line unchanged
        // under the pointer (see unInverted)
        if (folderPath !== undefined) {
          const isCollapsed = row.hiddenCount !== undefined;
          const unInverted = (shownColor?: string) => unInvertedIn(theme, shownColor);
          return (
            <Box key={`folder-${folderPath}`} flexDirection="row">
              <Button
                key={`fold-${folderPath}`}
                plain
                onPress={() => onToggleFolder(folderPath)}
              >
                <Text color={theme?.dimmed} hover={unInverted(theme?.dimmed)}>
                  {row.branch}
                </Text>
                <Text color={theme?.ansi.yellow} hover={unInverted(theme?.ansi.yellow)}>
                  {isCollapsed ? FOLDER_CLOSED_ICON : FOLDER_ICON}{" "}
                </Text>
                <Text color={theme?.ansi.blue} hover={unInverted(theme?.ansi.blue)}>
                  {row.label}
                </Text>
                {isCollapsed && (
                  <Text color={theme?.dimmed} hover={unInverted(theme?.dimmed)}>
                    {" "}
                    {row.hiddenCount}
                  </Text>
                )}
              </Button>
            </Box>
          );
        }
        const change = row.item!;
        const icon = fileIcon(row.label);
        return (
          <Box key={`file-${rowIndex}`} flexDirection="row" gap={1}>
            <Text wrap="truncate-end">
              <Text dimColor>{row.branch}</Text>
              <Text color={paint(theme, icon.color)}>{icon.glyph} </Text>
              {row.label}
            </Text>
            {change.added !== null && (
              <Text color={theme?.ansi.green}>+{change.added}</Text>
            )}
            {change.deleted !== null && change.deleted > 0 && (
              <Text color={theme?.ansi.red}>-{change.deleted}</Text>
            )}
            {change.added === null && !change.isNew && (
              <Text dimColor>bin</Text>
            )}
            <Text color={change.isNew ? theme?.ansi.green : theme?.ansi.yellow}>
              {EDITED_MARK}
            </Text>
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
