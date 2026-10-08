import { expect, test } from 'claude-code/testing'

import { fileIcon } from '../hooks/lib/icons'

test('picks an icon by extension, a default otherwise', () => {
  expect(fileIcon('register.tsx').glyph).toBe('')
  expect(fileIcon('index.d.ts').glyph).toBe('')
  expect(fileIcon('.gitignore').glyph).toBe('')
  expect(fileIcon('Makefile').glyph).toBe('')
})
