# skill-hint

Skills are easy to forget to load by hand. When a prompt is submitted, this mod adds a short reminder that only the model reads
(not shown in the transcript) naming the skill or command that matches: `mods` for `claude/mods/` or a mod, `/pr-reply` for PR
comments, `changelog` for Claude Code's news, `dotfiles` for `~/.bashrc.d`, `dots link` or a zsh module. A prompt matching nothing,
a slash command, or a message the person did not type gets no reminder.

## Example

The prompt `réponds aux commentaires de la PR` reaches the model followed by:

```
Skill hint: If the `/pr-reply` command exists, suggest it.
```
