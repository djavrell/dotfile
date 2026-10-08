import type { Roots } from "../../types";

// one drawn line of a file tree: `branch` is the "│  ├─ " guide in front of `label`,
// `item` the file on that line, absent on a folder line
export type TreeRow<Item> = { branch: string; label: string; item?: Item };

type TreeNode<Item> = { children: Map<string, TreeNode<Item>>; item?: Item };

// paths "a/b/x.ts", "a/b/y.ts", "c.md" -> a/b/ ├─ x.ts └─ y.ts, then c.md;
// a folder holding a single folder is merged into one line (claude/mods/session/)
export function buildTree<Item extends { path: string }>(
  items: readonly Item[],
): TreeRow<Item>[] {
  const root: TreeNode<Item> = { children: new Map() };
  for (const item of items) {
    let node = root;
    for (const segment of item.path.split("/").filter(Boolean)) {
      let child = node.children.get(segment);
      if (!child) {
        child = { children: new Map() };
        node.children.set(segment, child);
      }
      node = child;
    }
    node.item = item;
  }

  const rows: TreeRow<Item>[] = [];
  const walk = (node: TreeNode<Item>, guide: string) => {
    // folders first, then files, each alphabetical
    const entries = [...node.children].sort(
      ([nameA, nodeA], [nameB, nodeB]) =>
        Number(nodeA.children.size === 0) - Number(nodeB.children.size === 0) ||
        nameA.localeCompare(nameB),
    );
    entries.forEach(([name, child], entryIndex) => {
      let label = name;
      let shown = child;
      while (!shown.item && shown.children.size === 1) {
        const [onlyName, onlyChild] = [...shown.children][0]!;
        if (onlyChild.children.size === 0) break;
        label += `/${onlyName}`;
        shown = onlyChild;
      }
      const isLast = entryIndex === entries.length - 1;
      const isFolder = shown.children.size > 0;
      rows.push({
        branch: guide + (isLast ? "└─ " : "├─ "),
        label: isFolder ? `${label}/` : label,
        item: shown.item,
      });
      if (isFolder) walk(shown, guide + (isLast ? "   " : "│  "));
    });
  };
  walk(root, "");
  return rows;
}

// an absolute path as the pane shows it: from the repo root, else ~/..., else as is
export const displayPath = (absolutePath: string, pathRoots: Roots | null) => {
  if (pathRoots?.repo && absolutePath.startsWith(`${pathRoots.repo}/`))
    return absolutePath.slice(pathRoots.repo.length + 1);
  if (pathRoots?.home && absolutePath.startsWith(`${pathRoots.home}/`))
    return `~/${absolutePath.slice(pathRoots.home.length + 1)}`;
  return absolutePath;
};
