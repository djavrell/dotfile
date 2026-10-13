// one drawn line of a file tree: `branch` is the "│  ├─ " guide in front of `label`,
// `item` the file on that line, absent on a folder line; a folder line carries its full `folderPath`
// (the toggle's address), and `hiddenCount`, the files under it, when it is collapsed
export type TreeRow<Item> = {
  branch: string;
  label: string;
  item?: Item;
  folderPath?: string;
  hiddenCount?: number;
};

type TreeNode<Item> = { children: Map<string, TreeNode<Item>>; item?: Item };

const countFiles = (node: TreeNode<unknown>): number =>
  node.children.size === 0
    ? 1
    : [...node.children.values()].reduce((total, child) => total + countFiles(child), 0);

// paths "a/b/x.ts", "a/b/y.ts", "c.md" -> a/b/ ├─ x.ts └─ y.ts, then c.md;
// a folder holding a single folder is merged into one line (claude/mods/session/);
// a folder whose path is in `collapsed` is drawn without its children
export function buildTree<Item extends { path: string }>(
  items: readonly Item[],
  collapsed: ReadonlySet<string> = new Set(),
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
  const walk = (node: TreeNode<Item>, guide: string, parentPath: string) => {
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
      const branch = guide + (isLast ? "└─ " : "├─ ");
      if (!isFolder) {
        rows.push({ branch, label, item: shown.item });
        return;
      }
      const folderPath = parentPath + label;
      const isCollapsed = collapsed.has(folderPath);
      rows.push({
        branch,
        label: `${label}/`,
        folderPath,
        hiddenCount: isCollapsed ? countFiles(shown) : undefined,
      });
      if (!isCollapsed) walk(shown, guide + (isLast ? "   " : "│  "), `${folderPath}/`);
    });
  };
  walk(root, "", "");
  return rows;
}
