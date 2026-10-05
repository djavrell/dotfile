# Markdown I author

Applies to any `.md` file you write or substantially rewrite — plans, specs,
reviews, docs, rule files. On a small edit to an existing file, match that
file's convention instead of rewrapping unrelated content.

## Wrap prose at ~150 columns

Target ~150, err toward 140-145 for margin. Long unwrapped lines are hard to
read in narrow viewers and produce ugly diffs.

Continuation lines in a list indent to the content column (3 spaces after
`1. `, 2 after `- `) so the renderer keeps them in the same item.

**Never wrap:** code and SQL blocks (hard-wrapping breaks column alignment and
diffs), table rows (newline-delimited — a wrap splits the row), headings,
frontmatter, or URLs that break when split.
