import type { Elements } from 'claude-code';
import type { PaletteTheme } from 'palette';

import type { PaneRow } from '../../types';
import { paint } from '../lib/theme';

// the rows other mods publish (PaneRow: icon and key, linked when there is a url, then label, status, and a badge on the
// right), one line each. Nothing while no mod publishes any
export function TrackingSection({
  ui: { Box, Text, Link },
  theme,
  rows,
}: {
  ui: Pick<Elements[keyof Elements], 'Box' | 'Text' | 'Link'>;
  theme?: PaletteTheme;
  rows: readonly PaneRow[];
}) {
  if (rows.length === 0) return null;

  return (
    <Box flexDirection='column'>
      <Text weight='semibold'>Tracking</Text>
      {rows.map((row) => (
        <Box key={row.key} flexDirection='row' columnGap={2}>
          <Box flexShrink={1}>
            <Text wrap='truncate-end'>
              <Text color={paint(theme, 'ansi.cyan')}>
                {row.icon} {row.url ? <Link href={row.url}>{row.key}</Link> : row.key}
              </Text>{' '}
              {row.label}
              {row.status && <Text color={paint(theme, 'comment')}> · {row.status}</Text>}
            </Text>
          </Box>
          {row.badge && (
            <Box flexShrink={0}>
              <Text color={paint(theme, 'comment')}>{row.badge}</Text>
            </Box>
          )}
        </Box>
      ))}
      <Text> </Text>
    </Box>
  );
}
