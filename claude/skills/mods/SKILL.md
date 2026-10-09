---
name: mods
description: Work on the user's Claude Code mods (session pane, agents, palette, pr-viewer, lsp-first, or a new one) in ~/.bashrc.d/claude/mods/. Use when the user says the session is for working on a mod, asks to change, fix, debug or create a mod, or invokes /mods — from any working directory.
argument-hint: "[mod or task]"
---

You are working on the user's Claude Code mods, from whatever directory this session started in. Every path below is absolute.

## First, load the knowledge

1. Read `/home/kpr/.bashrc.d/claude/mods/CLAUDE.md` whole: how mods load, the architecture rule, the API constraints learned the
   hard way, the workflow and the style. It is the single source of that knowledge; follow it over anything you remember.
2. Read the `README.md` of the mod at hand (`/home/kpr/.bashrc.d/claude/mods/<mod>/README.md`) for what it is for.
3. For an API you have not used in these mods yet (a new event, element or noun), load the `plugin-authoring` skill, or grep the mod's
   own typings (`<mod>/.claude-plugin/types/claude-code/index.d.ts`) for the name at hand. Never read that file whole.

Then say in one line which mod and task you understood, and start (or ask, when no task was given).

## Workflow

- **Auto mode**: Edit/Write under `/home/kpr/.bashrc.d/claude/mods/` fails. Copy the mod fresh to the session's scratchpad
  (`<scratchpad>/mods/<mod>/`, replacing any older copy), edit there, check there, then `cp` the changed files back. Before copying
  back, `diff -r` the copy against the original minus your edits if the original may have changed meanwhile.
- **Manual mode**: edit `/home/kpr/.bashrc.d/claude/mods/<mod>/` directly.
- **Checks**, all three must pass before a change counts as done, run on the folder you edited:
  `claude plugin validate <mod folder>`, `claude plugin test <mod folder>`, `npx -y -p typescript tsc -p <mod folder>`.
- A saved file reloads its mod in a running session; a **new** mod loads only in a session started from a new shell.
- A pure helper gets a test in the mod's `tests/` (`claude-code/testing`, single quotes, no semicolons).

## Rules

- Before each step, recap it to the user in a few lines; wait for a go on anything beyond what was asked.
- Never delete a file or a feature unasked. Never commit unless asked. Never touch `claude/settings.json` without explicit consent.
- Descriptive names, no one-letter variables; the formatting already in the file (double quotes and semicolons in hook files).
- Code is read by humans: comment the why, name the regexes, split a long function into named steps.
- Learned something about the API that is not in `CLAUDE.md` yet? Propose the line to add there; add it once the user agrees.
- A mod's `README.md` is an entry point (what it is for, a mini example), not a file listing: update it only when that changes.
