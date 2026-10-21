---
name: changelog
description: Résume les dernières versions du changelog de Claude Code. Utiliser quand l'utilisateur demande les nouveautés, le changelog ou ce qui a changé dans Claude Code.
argument-hint: "[nombre de versions, défaut 3]"
---

Version installée : !`claude --version`

Changelog (les 10 dernières versions) :

!`curl -sL https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md | awk '/^## /{n++} n>=1 && n<=10'`

Résume en français les $ARGUMENTS dernières versions ci-dessus (3 si aucun nombre n'est donné) :

- une section `## <version>` par version, en commençant par la plus récente ;
- regroupe les entrées par thème (Nouveautés, Sécurité/permissions, Fiabilité, Améliorations) et ne garde que l'essentiel ;
  une petite version tient en 2-3 puces ;
- termine par une ligne sur ce qui concerne cet environnement : zsh, WSL, mods/plugins.

## Vérifier les mods

Saute cette étape si les versions résumées n'ont aucune entrée sur les mods : hooks de mod (`tool.call`, `tool.check`,
`settings.read`, `ui.render`...), `$.<noun>`, `Button`/`Box`, panes, `claude plugin validate|test`, rechargement de mod. Dis-le en
une ligne.

Sinon, lance un agent `Explore` (lecture seule) avec `model: "sonnet"` et donne-lui, mot pour mot, les entrées du changelog qui touchent les mods. Sa
mission, sur `~/.bashrc.d/claude/mods/` (hors `node_modules` et `.claude-plugin/types/`), en s'appuyant sur `claude/mods/CLAUDE.md` :

- **cassé** : un mod qui utilise une API changée ou retirée ;
- **contournement devenu inutile** : un bug corrigé pour lequel un mod, un commentaire `ponytail:` ou une ligne de la section « API
  constraints learned the hard way » de `claude/mods/CLAUDE.md` contourne ou documente encore l'ancien comportement ;
- **opportunité** : une nouvelle API qui simplifierait un mod existant (pas de nouvelle fonctionnalité spéculative).

Il répond par un tableau `Entrée | Mod (fichier:ligne) | Constat | Action proposée`, « rien à changer » pour une entrée sans
effet.

Ajoute une section `## Mods` après le résumé avec ce tableau tel quel. N'applique aucune modification : l'utilisateur trie d'abord.
