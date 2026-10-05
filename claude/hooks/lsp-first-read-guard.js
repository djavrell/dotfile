#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');
const crypto = require('crypto');
const { buildWarmupInstructions, buildFileWarmupCall } = require('./lib/detect-lsp-provider');

/**
 * Build a copy-pasteable warmup call parametrized by the exact file the
 * agent is about to Read. This is project-agnostic: it uses the file path
 * from the hook input instead of guessing a symbol name from the filename,
 * so it works in any project regardless of export conventions.
 */
function buildConcreteCall(filePath) {
  const call = buildFileWarmupCall(filePath, '  ');
  if (!call) return '';
  return `\nCONCRETE CALL FOR THIS FILE (works in any project):\n${call}\n`;
}

const STATE_DIR = path.join(os.homedir(), '.claude', 'state');
const CODE_EXTENSIONS = /\.(ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|vue|svelte|cpp|c|h|hpp)$/i;
const ALLOW_NON_CODE_EXT = /\.(md|txt|log|json|jsonc|yaml|yml|env|csv|toml|xml|sql|sh|css|scss|html|lock|ini|conf|cfg)$/i;
const ALLOW_CONFIG_PATTERNS = /(\.config\.|tsconfig|next\.config|vite\.config|webpack\.config|rollup\.config|babel\.config|jest\.config|vitest\.config|tailwind\.config|postcss\.config|eslint|prettier|package\.json|pnpm-lock|yarn\.lock)/i;
const ALLOW_PATH_PATTERNS = /(^|\/)(\.task|\.claude|\.git|node_modules|build|dist|out|public|scripts|docs?|knowledge-vault|supabase\/migrations|coverage|\.next|\.turbo|__tests__|__mocks__)(\/|$)/i;
const ALLOW_TEST_PATTERNS = /\.(test|spec)\.(ts|tsx|js|jsx|mjs|cjs|py)$/i;

const FLAG_EXPIRY_MS = 24 * 60 * 60 * 1000;
const WARN_AT = 3;

function getFlagPath() {
  const cwd = process.cwd();
  const hash = crypto.createHash('md5').update(cwd).digest('hex').slice(0, 12);
  return path.join(STATE_DIR, `lsp-ready-${hash}`);
}

function ensureStateDir() {
  try { if (!fs.existsSync(STATE_DIR)) fs.mkdirSync(STATE_DIR, { recursive: true }); } catch {}
}

function readFlag(fp) {
  try {
    if (!fs.existsSync(fp)) return null;
    const d = JSON.parse(fs.readFileSync(fp, 'utf8'));
    if (Date.now() - (d.timestamp || 0) > FLAG_EXPIRY_MS) return null;
    return d;
  } catch { return null; }
}

function writeFlag(fp, flag) {
  try { ensureStateDir(); fs.writeFileSync(fp, JSON.stringify(flag)); } catch {}
}

function emitWarning(msg) { console.log(JSON.stringify({ systemMessage: msg })); }

let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', d => { raw += d; });
process.stdin.on('end', () => {
  let data;
  try { data = JSON.parse(raw); } catch { process.exit(0); }
  if (data.tool_name !== 'Read') process.exit(0);

  // String coercion: non-string input would throw on .trim() and fail-open.
  const filePath = String(data.tool_input?.file_path ?? '').trim();
  if (!filePath) process.exit(0);

  if (ALLOW_NON_CODE_EXT.test(filePath)) process.exit(0);
  if (ALLOW_CONFIG_PATTERNS.test(path.basename(filePath))) process.exit(0);
  if (ALLOW_PATH_PATTERNS.test(filePath)) process.exit(0);
  if (ALLOW_TEST_PATTERNS.test(filePath)) process.exit(0);
  if (!CODE_EXTENSIONS.test(filePath)) process.exit(0);

  // ── ADVISORY ONLY — this hook must never block. ──────────────────────────
  // Edit requires a prior Read of the target file. A hard block here therefore
  // makes Edit unreachable, and the fallback is `cat > f <<'TS'` or a python
  // heredoc doing read_text()/write_text() — which trips no hook, shows the
  // user no diff, and silently no-ops when a replace anchor misses.
  // Enforcement belongs on the tools LSP actually replaces:
  //   - symbol search  -> bash-grep-block.js / lsp-first-guard.js (hard block)
  //   - shell file I/O -> bash-file-read-block.js (hard block, points at Read/Edit)
  // Reading a file you are about to edit is not navigation, so here we nudge.
  const flagPath = getFlagPath();
  const flag = readFlag(flagPath) || {
    cwd: process.cwd(), warmup_done: false, nav_count: 0, read_count: 0, read_files: [],
  };

  const readFiles = Array.isArray(flag.read_files) ? flag.read_files : [];
  const navCount = flag.nav_count || 0;
  const alreadyRead = readFiles.includes(filePath);
  const nextReadNum = alreadyRead ? readFiles.length : readFiles.length + 1;

  // One nudge only, at the WARN_AT-th distinct file, and only if navigation
  // has not been used at all. Repeated warnings just train the agent to route
  // around Read entirely.
  if (!alreadyRead && navCount === 0 && nextReadNum === WARN_AT) {
    emitWarning(
      `⚠️ LSP-FIRST (Read #${nextReadNum} this session, 0 LSP navigation calls)\n` +
      `Reading many whole files to find something is what LSP replaces.\n` +
      `If you are locating a symbol rather than editing a known file, prefer:\n` +
      buildWarmupInstructions('  ').join('\n') + '\n' +
      buildConcreteCall(filePath)
    );
  }

  if (!alreadyRead) {
    readFiles.push(filePath);
    flag.read_files = readFiles;
    flag.read_count = readFiles.length;
  }
  flag.timestamp = Date.now();
  writeFlag(flagPath, flag);
  process.exit(0);
});
