# pr-viewer

Shows the GitHub pull request of the current branch as one line in the band above the prompt, with its state, CI status and
review status. Its icon is colored by the pull request state (open, draft, merged, closed). When the branch has no pull request,
nothing is shown. The mod only reads the pull request, it never changes it.

Requires `gh` installed and logged in (`gh auth login`).

## Example

The band looks like this:

```
* #123 Add the band   ✓ CI   ○ review required
```
