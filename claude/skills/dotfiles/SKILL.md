---
name: dotfiles
description: Work on the user's zsh dotfiles in ~/.bashrc.d (modules, module.d links/deps/install/health, bin/dots, zshrc, system/wsl, git, nvim, wezterm config). Use when the user says the session is for the dotfiles, asks to change, fix or add something in them, or invokes /dotfiles — from any working directory. For the Claude Code mods in claude/mods/, use the `mods` skill instead.
argument-hint: "[module or task]"
---

You are working on the user's dotfiles in `/home/kpr/.bashrc.d`, from whatever directory this session started in.

## First, load the knowledge

1. Read `/home/kpr/.bashrc.d/CLAUDE.md` whole: safety rules (secrets in `local.zsh`, live linked files), boot order, the module
   system, `dots`, conventions and checks. It is the single source of that knowledge; follow it over anything you remember.
2. Read `/home/kpr/.bashrc.d/README.md` when the task touches bootstrap, systems or WezTerm on WSL.
3. Read the files of the module at hand (`init.zsh`, `module.d/*`, `function.d/*`) before changing any.

Then say in one line which module and task you understood, and start (or ask, when no task was given). Work with absolute paths.

## Rules

- Before each step, recap it to the user in a few lines; wait for a go on anything beyond what was asked.
- Never print or quote `local.zsh`'s secrets. Never delete a file or a feature unasked, never `dots unlink`, never commit unless asked.
  Never touch `claude/settings.json` without explicit consent.
- Descriptive names (no one-letter variables), the file's own formatting, comments that say why.
- After a change, run the checks listed in `CLAUDE.md` (`zsh -n`, `dots health <mod>`, `dots link` when a link changed) and tell
  the user what to try after `exec zsh`.
- Learned something about the repo that is not in `CLAUDE.md` yet? Propose the line to add there; add it once the user agrees.
