# session

A side pane that shows what the session is doing at a glance: the main agent card and its subagents, the skills used,
the files changed in the repo, and the context window usage. It opens on session start, and `/session` toggles it.

## Example

```
╭────────────────────────────────────────────────╮
│ * opus-4-5   🧠 ▰▰▰▱▱ high   💰 $1.2345        │
│ ⚡ 23%/41% ↺ 2h15m   󰃨 97%   ⏱ 42m07s          │
╰────────────────────────────────────────────────╯
├─ ✓ * Explore find the pane hooks
│  ▰▰▰▰▰▰ 6/6
└─ ● * general-purpose write the README
   ▰▰▰▱ 3/4

Skills
code-review, simplify

Files
└─ * claude/mods/session/
   ├─ * README.md                          +72 ●
   └─ * register.tsx                    +4 -1 ●
2 edited · +76 -1

Context
▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱
* 3k  * 17k  * 2k  * 26k
24%  📊 48k/200k
```

```
/session         toggle the pane
/context-icons   list the Context legend's icons and grid cells
```
