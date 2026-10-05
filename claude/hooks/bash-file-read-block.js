#!/usr/bin/env node
'use strict';

// bash-file-read-block.js — PreToolUse hook (matcher: Bash)
//
// Blocks shell file I/O on source files and points at the real tool:
//   cat / sed -n / head / tail / awk on foo.ts   -> Read
//   cat > foo.ts <<'TS' / python write_text()    -> Write or Edit
//
// Rationale: the LSP-first guards only covered Read/Grep/Glob and grep-in-Bash,
// so `cat foo.ts` and `python3 - <<'PY' ... write_text()` were the frictionless
// way around them. Writing that way costs the user the reviewable diff, lets
// `cat >` truncate a file the agent never read, and makes a missed replace
// anchor a silent no-op instead of a loud Edit failure.
//
// This hook is about tool choice, not about LSP: for "show me this file" the
// answer is Read, and for "change this file" it is Edit. Symbol search stays
// with bash-grep-block.js — this hook must not second-guess it.
//
// SCOPE DISCIPLINE (learned the hard way, see notes at each guard):
//   - Only the command that OPENS the file counts. `… | head -40` is a
//     downstream filter, not a reader.
//   - Heredoc bodies are payload, not command. They are stripped before
//     anything is matched, or the source inside them triggers every rule.
//   - Scratch directories are for throwaway scripts. Leave them alone.

const ZERO_WIDTH = /[\u00AD\u200B-\u200F\u2060-\u2064\uFEFF]/g;

const CODE_EXT = String.raw`\.(?:ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|vue|svelte|cpp|c|h|hpp)`;
const CODE_FILE = new RegExp(`[\\w./@~-]+${CODE_EXT}\\b`, 'i');

// Commands that read a file's contents when they are the one naming it.
const READER = /^(?:cat|sed|head|tail|awk|nl|strings|less|more|bat)\b/i;

// Paths where this guard is noise rather than help: scratch space, throwaway
// scripts, VCS internals, build output.
const EXEMPT_PATH = /(?:^|[\/\\])(?:\.claude|\.git|\.task|coverage|\.next|\.turbo|knowledge-vault|node_modules[\/\\]\.bin)(?:[\/\\]|$)|(?:^|[\/\\])(?:scratchpad|tmp|temp)(?:[\/\\])|^\/tmp[\/\\]/i;

// Exit 2 sends stderr back to the model as the block reason. Kept distinct
// from bash-grep-block.js's stdout `{decision:"block"}` form on purpose:
// emitting both channels at once makes it ambiguous which one the host honours.
function emitBlock(reason) {
  process.stderr.write(`\n⛔ ${reason}\n\n`);
  process.exit(2);
}

// Remove heredoc bodies, keeping the header line. Without this, a heredoc
// writing TypeScript has `import './x.js'` in its body, which reads as a code
// file to every rule below, and arrow functions (`=>`) read as redirects.
function stripHeredocs(cmd) {
  const re = /<<-?\s*(['"]?)([A-Za-z_][\w]*)\1/g;
  let out = cmd, m;
  while ((m = re.exec(cmd)) !== null) {
    const tag = m[2];
    const bodyStart = cmd.indexOf('\n', m.index);
    if (bodyStart === -1) continue;
    const end = cmd.search(new RegExp(`\\n\\s*${tag}\\s*(?:\\n|$)`));
    const body = end === -1 ? cmd.slice(bodyStart) : cmd.slice(bodyStart, end);
    if (body) out = out.split(body).join('\n');
  }
  return out;
}

// Split a command line into pipeline/list segments so each can be judged by
// the program that actually runs it. Quotes are respected so a `;` or `|`
// inside a grep pattern does not split the segment.
function segments(cmd) {
  const parts = [];
  let buf = '', quote = null;
  for (let i = 0; i < cmd.length; i++) {
    const ch = cmd[i];
    if (quote) {
      if (ch === quote && cmd[i - 1] !== '\\') quote = null;
      buf += ch;
      continue;
    }
    if (ch === '"' || ch === "'") { quote = ch; buf += ch; continue; }
    if (ch === '|' || ch === ';' || ch === '\n' || ch === '&') {
      if (buf.trim()) parts.push(buf.trim());
      buf = '';
      continue;
    }
    buf += ch;
  }
  if (buf.trim()) parts.push(buf.trim());
  // Strip leading env assignments and `sudo`/`command` wrappers.
  return parts.map(p => p.replace(/^(?:\w+=\S*\s+)*(?:sudo\s+|command\s+)?/, '').trim()).filter(Boolean);
}

let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', d => { raw += d; });
process.stdin.on('end', () => {
  let data;
  try { data = JSON.parse(raw); } catch { process.exit(0); }
  if (data.tool_name !== 'Bash') process.exit(0);

  const original = String(data.tool_input?.command ?? '').trim().replace(ZERO_WIDTH, '');
  if (!original) process.exit(0);
  const cmd = stripHeredocs(original);

  // Working inside the Claude config tree itself — these hooks are .js files,
  // and neither LSP nor the project tooling indexes them.
  const cwd = String(data.cwd ?? process.cwd());
  if (/[\/\\]\.claude(?:[\/\\]|$)/.test(cwd)) process.exit(0);

  const segs = segments(cmd);

  // ── Writes ────────────────────────────────────────────────────────────────
  // `cat > f.ts`, `tee f.ts`, `>> f.ts`, and python read_text/write_text
  // round-trips are all "edit this source file" wearing a shell costume.
  // Judged per segment, and only against a redirect target — a bare mention
  // of a .ts path elsewhere in the pipeline is not a write.
  // NB the trailing (?![A-Za-z0-9_]): without it the `c` alternative in
  // CODE_EXT matches the `.c` inside `geo_risk.csv`, and a data file gets
  // reported as a blocked source write. CODE_FILE already carries a \b for
  // the same reason — these two must not drift apart.
  const EXT_END = String.raw`(?![A-Za-z0-9_])`;
  const redirect = new RegExp(String.raw`>>?\s*['"]?([\w./@~-]+${CODE_EXT})${EXT_END}`, 'i');
  const teeTarget = new RegExp(String.raw`\btee\b[^|]*?['"]?([\w./@~-]+${CODE_EXT})${EXT_END}`, 'i');
  const pyWrite = /\bwrite_text\s*\(|\bfs\.writeFileSync\b|\bopen\s*\([^)]*['"]\s*[wa]\+?\s*['"]/;

  for (const seg of segs) {
    const hit = seg.match(redirect) || seg.match(teeTarget);
    const target = hit && hit[1];
    if (target && !EXEMPT_PATH.test(target)) {
      emitBlock(
        `TOOL-CHOICE: writing a source file from the shell is blocked.\n` +
        `  target: ${target}\n\n` +
        `Use the file tools instead:\n` +
        `  new file        -> Write(file_path, content)\n` +
        `  existing file   -> Read it, then Edit(file_path, old_string, new_string)\n\n` +
        `Why: Write/Edit render a diff the user can review, refuse to clobber a\n` +
        `file that was never read, and fail loudly when an anchor does not match.\n` +
        `A heredoc or write_text() does none of those.\n\n` +
        `Scratch scripts under a scratchpad/ or /tmp path are exempt.`
      );
    }
  }

  if (pyWrite.test(original)) {
    const m = original.match(CODE_FILE);
    if (m && !EXEMPT_PATH.test(m[0])) {
      emitBlock(
        `TOOL-CHOICE: patching a source file from a script is blocked.\n` +
        `  target: ${m[0]}\n\n` +
        `Use Read + Edit(file_path, old_string, new_string). A python\n` +
        `read_text()/replace()/write_text() round-trip silently writes the file\n` +
        `back unchanged when the anchor does not match; Edit fails loudly.`
      );
    }
  }

  // ── Reads ─────────────────────────────────────────────────────────────────
  // A segment counts only if the reader is the command being run AND the code
  // file is one of ITS arguments. This is what keeps the hook out of:
  //   `npx eslint src/app.ts 2>&1 | tail -30`   (eslint runs; tail filters)
  //   `grep -n 'x' foo.ts | head -40`           (grep's jurisdiction)
  // Counting/hashing consumers want a number, not the contents — `Read` is not
  // a substitute for `cat f.ts | wc -l`.
  const countingOnly = /\|\s*(?:wc|md5sum|sha\d+sum|cksum|shasum)\b/i.test(cmd);

  for (const seg of segs) {
    if (!READER.test(seg)) continue;
    const m = seg.match(CODE_FILE);
    if (!m) continue;                       // e.g. a bare `head -40` filter
    if (EXEMPT_PATH.test(m[0])) continue;
    if (countingOnly) continue;
    const file = m[0];

    if (/^sed\b/i.test(seg) && /\s-i\b/.test(seg)) {
      emitBlock(
        `TOOL-CHOICE: in-place sed on a source file is blocked.\n` +
        `  target: ${file}\n\n` +
        `Use Read + Edit(file_path, old_string, new_string) so the change is\n` +
        `shown as a diff and fails loudly if the anchor is missing.`
      );
    }

    emitBlock(
      `TOOL-CHOICE: reading a source file through the shell is blocked.\n` +
      `  target: ${file}\n\n` +
      `Use Read("${file}") — it is line-numbered, range-limited via\n` +
      `offset/limit, and registers the file so Edit can modify it afterwards.\n` +
      `Shell readers do not, which is how whole-file cat/sed sessions start.\n\n` +
      `If you are locating a symbol rather than viewing a known file, use LSP:\n` +
      `  mcp__cclsp__find_definition / find_references / find_workspace_symbols`
    );
  }

  process.exit(0);
});
