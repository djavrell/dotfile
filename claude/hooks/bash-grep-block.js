#!/usr/bin/env node
'use strict';

// bash-grep-block.js — PreToolUse hook (matcher: Bash)
// Blocks grep/rg/ag/ack with code symbols in shell commands.
// Suggests LSP equivalent for the active provider (cclsp / Serena / ...).
// Allows: git grep, non-code paths, non-code file types.

const { buildSuggestion, buildStructuredBlockResponse } = require('./lib/detect-lsp-provider');

// Zero-width / formatting chars that would split tokens invisibly and
// bypass ASCII regex symbol detection.
const ZERO_WIDTH = /[\u00AD\u200B-\u200F\u2060-\u2064\uFEFF]/g;

let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', d => { raw += d; });
process.stdin.on('end', () => {
  let data;
  try { data = JSON.parse(raw); } catch { process.exit(0); }
  if (data.tool_name !== 'Bash') process.exit(0);

  // String coercion: non-string command would throw on .trim() and fail-open.
  // Zero-width strip: prevents `grep\u200BUserFunc` evasion.
  const cmd = String(data.tool_input?.command ?? '').trim().replace(ZERO_WIDTH, '');
  // Case-insensitive to catch `GREP`, `RG` variants
  if (!/\b(grep|rg|ag|ack)\b/i.test(cmd)) process.exit(0);
  if (/\bgit\s+grep\b/i.test(cmd)) process.exit(0);

  // ── False-positive exits ─────────────────────────────────────────────────
  // These fire before symbol detection because the "symbol" in them is not a
  // search term at all, and a misfiring guard teaches the agent to avoid the
  // guarded tool rather than to reach for LSP.

  // (1) Working inside the Claude config tree. Its .js hooks are not in any
  //     LSP workspace, so find_workspace_symbols() cannot answer here.
  const cwd = String(data.cwd ?? process.cwd());
  if (/[\/\\]\.claude(?:[\/\\]|$)/.test(cwd)) process.exit(0);

  // (2) Inverted match — `grep -v` / `-Ev` removes lines. Nobody searches for
  //     a definition by excluding it; this is noise filtering.
  //     e.g. `npm run architecture 2>&1 | grep -Ev 'DeprecationWarning'`
  if (/\b(?:grep|rg|ag|ack)\s+(?:-\w*v\w*|--invert-match)\b/i.test(cmd)) process.exit(0);

  // (3) grep as a filter on another command's OUTPUT, not on files. The
  //     pattern is matched against a program's stdout, so LSP has nothing to
  //     say about it. Requires: a pipe, grep after it, and a recognised
  //     producer on the left.
  const pipePos = cmd.indexOf('|');
  const grepPos = cmd.search(/\b(grep|rg|ag|ack)\b/i);
  if (pipePos !== -1 && pipePos < grepPos && !/\bxargs\b|-exec\b/.test(cmd)) {
    const producer = cmd.slice(0, pipePos).trim().replace(/^\S*=\S*\s+/, '');
    if (/^(?:npm|npx|pnpm|yarn|node|deno|bun|git|docker|make|kubectl|tsc|eslint|jest|vitest|ps|env|printenv|ls|find|wc|sort|uniq|head|tail|curl|dig)\b/i.test(producer)) {
      process.exit(0);
    }
  }
  if (/(?:^|[\/\\])(?:supabase[\/\\]migrations|\.task|\.claude|node_modules|knowledge-vault)(?:[\/\\]|$)/i.test(cmd)) process.exit(0);
  if (/--include=?\S*\.(sql|md|json|yaml|yml|txt|env|sh|css|scss|log)\b/i.test(cmd)) process.exit(0);

  // (4) Search WITHIN one already-identified file. `grep -n "X" groups.module.ts`
  //     answers "where in this file", which no LSP call does more cheaply —
  //     find_workspace_symbols is workspace-wide and find_references needs the
  //     symbol to resolve first. Blocking it leaves no legal path, and the
  //     observed result is the agent mutating the pattern to dodge the regex
  //     (ImportSessions -> mportSessions) rather than reaching for LSP.
  //     Recursive / multi-root / --include searches stay blocked.
  if (!/\s-\w*[rR]\w*\b|--recursive|--include/i.test(cmd)) {
    const fileArgs = (cmd.match(/(?:^|\s)['"]?[\w./@~-]+\.(?:ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|vue|svelte)['"]?(?=\s|$|\||;)/gi) || []);
    if (fileArgs.length === 1) process.exit(0);
  }

  // (5) Counting, not reading. `grep -c` returns a number; there is no LSP
  //     operation that counts occurrences, so there is nothing to redirect to.
  //     Known hole: `-c` is one letter, so `grep -rc "Symbol" src/` slips
  //     through. Accepted — it still returns no source, only a tally.
  if (/\b(?:grep|rg|ag|ack)\s+(?:-\w*c\w*|--count)\b/i.test(cmd)) process.exit(0);

  // (6) Context flags (-A/-B/-C). The agent is asking for the surrounding
  //     source lines. LSP returns positions, never the code around them.
  if (/\s-[ABC]\s?\d|--(?:after|before)-context\b|--context\b/i.test(cmd)) process.exit(0);

  // Python is the one language here where snake_case names are real symbols
  // that pylsp indexes. Everywhere else snake_case is a database identifier.
  const isPythonTarget = /\.py\b|--include=?\S*\.py\b|-t\s*py\b/i.test(cmd);

  const cleaned = cmd.replace(/\\"/g, '"');
  const patternMatch =
    cleaned.match(/\b(?:grep|rg|ag|ack)\s+(?:-\S+\s+)*"([^"]+)"/i) ||
    cleaned.match(/\b(?:grep|rg|ag|ack)\s+(?:-\S+\s+)*'([^']+)'/i) ||
    cleaned.match(/\b(?:grep|rg|ag|ack)\s+(?:(?:-\w+\s+(?:[a-z]+\s+)?)*?)([A-Z][a-zA-Z]\w+)/i);

  if (!patternMatch) process.exit(0);

  const fullPattern = patternMatch[1];

  // (7) The pattern is a REGEX, not an identifier — it carries an unescaped
  //     wildcard or quantifier. If the agent knew the exact name it would not
  //     need one, and LSP can only look up exact names.
  //       is.Optional / Optional?  -> pattern search, allow
  //       ImportSessionId\.        -> escaped dot, still a symbol, still blocked
  //     Escaped backslashes are collapsed first so `\\.` reads as an escape.
  if (/(?<!\\)[.?*+[]/.test(fullPattern.replace(/\\\\/g, ''))) process.exit(0);

  // Strip zero-width chars from the matched pattern (already stripped from cmd,
  // but an explicit safety for pattern extraction edge cases).
  // NOTE: split on BOTH `|` and `.` — previously we stripped dots, which merged
  // dotted expressions like `mcp.Tool` into `mcpTool` (camelCase false positive).
  // Now we split on dots so each side is evaluated independently.
  const parts = fullPattern
    .split(/\\?\||\./)
    .map(p => p
      .replace(ZERO_WIDTH, '')
      // Drop regex escape sequences WHOLE. Stripping only the backslash turned
      // `Dao\b` into `Daob`, which then reads as a CamelCase symbol and blocked
      // a legitimate word-boundary grep. Same for \w \s \d \B etc.
      .replace(/\\[a-zA-Z]/g, ' ')
      .replace(/[*+?^${}()[\]\\]/g, '')
      .trim())
    .filter(Boolean);
  const symbols = parts.filter(p => {
    if (p.length < 4 || /\s/.test(p)) return false;
    const skip = [
      /^(TODO|FIXME|HACK|XXX|NOTE)/i,
      /^console\b/, /^import\b/, /^export\b/, /^http/i, /^\d/,
      /^[A-Z_]{3,}$/, /^[a-z]{1,8}$/, /^[a-z]+-[a-z]+/,
    ];
    if (skip.some(rx => rx.test(p))) return false;

    // NOTE: dotted-symbol regex removed — after splitting on `.` above,
    // no `p` can contain a dot, so the path was dead code.
    // (8) snake_case with 2+ underscores is a real symbol in Python, but in a
    //     TS/JS codebase it is a database table or column (geo_control_synthesis)
    //     — tsserver does not index those, so no LSP call can ever answer it.
    return (/^[a-z][a-zA-Z0-9]{3,}$/.test(p) && /[A-Z]/.test(p)) ||
           /^[A-Z][a-zA-Z][a-zA-Z0-9]{2,}$/.test(p) ||
           (/^[a-z]+(_[a-z]+){2,}$/.test(p) && p.length >= 9 && isPythonTarget);
  });

  // SECURITY: only allow the safe-prefix pipe bypass AFTER confirming no code symbols.
  // Previously `echo x | grep SomeCamelFunc` passed because the bypass ran before
  // symbol detection. Now: if symbols present, no bypass — always proceed to block.
  if (symbols.length === 0) {
    const targetsCodeEarly =
      /\bsrc[\\/]|\bapp[\\/]|components[\\/]|lib[\\/]|hooks[\\/]|utils[\\/]|services[\\/]|actions[\\/]/i.test(cmd) ||
      /\.tsx?\b|\.jsx?\b/i.test(cmd);
    const hasNonCodeTargetEarly = /\.(sql|md|json|yaml|yml|txt|env|sh|css|scss|log|toml|xml)\b/i.test(cmd) && !targetsCodeEarly;
    if (hasNonCodeTargetEarly) process.exit(0);

    const isSimplePipe = /\|/.test(cmd) && !/xargs|exec/.test(cmd);
    const grepPos = cmd.search(/\b(grep|rg|ag|ack)\b/i);
    const pipePos = cmd.indexOf('|');
    if (isSimplePipe && pipePos !== -1 && pipePos < grepPos) {
      const beforePipe = cmd.substring(0, pipePos).trim();
      if (/^(git|npm|npx|pnpm|node|echo|cat\s+\S+\.(?:json|md|txt|log|ya?ml))/i.test(beforePipe) ||
          /^(ls|wc|head|tail|sort|uniq)\b/i.test(beforePipe)) {
        process.exit(0);
      }
    }
    process.exit(0);
  }

  const targetsCode =
    /\bsrc[\\/]|\bapp[\\/]|components[\\/]|lib[\\/]|hooks[\\/]|utils[\\/]|services[\\/]|actions[\\/]/i.test(cmd) ||
    /\.tsx?\b|\.jsx?\b/i.test(cmd) ||
    /-t\s+(ts|tsx|js|jsx|typescript|javascript)\b/i.test(cmd) ||
    /--type[= ](ts|tsx|js|jsx|typescript)\b/i.test(cmd) ||
    /\bfind\b.*\b(src|app|components|lib)\b/.test(cmd) ||
    /\bxargs\b.*\b(grep|rg|ag|ack)\b/i.test(cmd) ||
    /-exec\s+(grep|rg|ag|ack)\b/i.test(cmd);

  const hasNonCodeTarget =
    /\.(sql|md|json|yaml|yml|txt|env|sh|css|scss|log|toml|xml)\b/i.test(cmd) &&
    !targetsCode;

  // Symbols are present — only bypass if the command is unambiguously
  // targeting non-code files AND doesn't touch code paths.
  if (hasNonCodeTarget && !targetsCode) process.exit(0);

  const suggestions = symbols.map(sym => {
    const intent = /^[A-Z]/.test(sym) ? 'symbol_search' : 'references';
    return `  ${sym}:\n${buildSuggestion(sym, intent, '    ')}`;
  }).join('\n');

  process.stderr.write(
    `\n⛔ LSP-FIRST: Blocked grep/rg — found ${symbols.length} code symbol(s): ${symbols.join(', ')}\n` +
    `LSP is always connected. Use:\n${suggestions}\n\n`
  );

  const intent = /^[A-Z]/.test(symbols[0]) ? 'symbol_search' : 'references';
  console.log(JSON.stringify(buildStructuredBlockResponse({
    hook: 'bash-grep-block',
    symbols,
    intent,
    reason: `LSP-FIRST: Pattern contains code symbols [${symbols.join(', ')}]. Use LSP:\n${suggestions}`,
  })));
});
