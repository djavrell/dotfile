import type { Ui } from "../lib/theme";

export function SkillsSection({
  ui: { Box, Text },
  skillList,
}: {
  ui: Ui;
  skillList: readonly string[];
}) {
  return (
    <Box flexDirection="column">
      <Text bold>Skills</Text>
      {skillList.length === 0 ? (
        <Text dimColor>None.</Text>
      ) : (
        <Text wrap="wrap">{skillList.join(", ")}</Text>
      )}
    </Box>
  );
}
