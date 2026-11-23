import type { Register } from 'claude-code';

import { skillHints } from './lib/hints';

// only what the person typed: a peer's message, a notification or a plugin's prompt gets no hint
const PERSON_ORIGINS = new Set(['composer', 'bridge']);

// `context` is what the model reads beside the prompt; a classic hook's systemMessage reaches the user only
export const register: Register = on => {
  on('prompt.submit', async (_, event, next) => {
    if (event.command || event.isMeta || !PERSON_ORIGINS.has(event.origin.kind)) return next(event);
    const hints = skillHints(event.text);
    if (hints.length === 0) return next(event);
    return next({ ...event, context: [...(event.context ?? []), `Skill hint: ${hints.join(' ')}`] });
  });
};
