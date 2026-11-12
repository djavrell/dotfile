---
name: changelog
description: Résume les dernières versions du changelog de Claude Code. Utiliser quand l'utilisateur demande les nouveautés, le changelog ou ce qui a changé dans Claude Code.
argument-hint: "[nombre de versions, défaut 3]"
---

Version installée : !`claude --version`

Nombre de versions demandé : `$ARGUMENTS` (3 si vide). Récupère-les avec cette commande, `<N>` remplacé par ce nombre :

```bash
curl -sfL https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md | awk -v wanted=<N> '/^## /{n++} n>=1 && n<=wanted'
```

Si la sortie est vide (hors ligne, GitHub indisponible), dis-le en une ligne et arrête-toi : ne résume rien de mémoire.

Résume ces versions en français :

- une section `## <version>` par version, en commençant par la plus récente ; marque `(pas encore installée)` celles plus récentes
  que la version installée ;
- regroupe les entrées par thème (Nouveautés, Sécurité/permissions, Fiabilité, Améliorations) et ne garde que l'essentiel ;
  une petite version tient en 2-3 puces ;
- termine par une ligne sur ce qui concerne cet environnement : zsh, WSL, mods/plugins.

## Vérifier les mods

Saute cette étape si les versions résumées n'ont aucune entrée sur les mods : hooks de mod (`tool.call`, `tool.check`,
`settings.read`, `ui.render`...), `$.<noun>`, `Button`/`Box`, panes, `claude plugin validate|test`, rechargement de mod. Dis-le en
une ligne.

Sinon, lance un agent `general-purpose` avec `model: "sonnet"`, en lui précisant qu'il est en lecture seule (aucune modification de
fichier), et donne-lui, mot pour mot, les entrées du changelog qui touchent les mods. Sa mission, sur `~/.bashrc.d/claude/mods/`
(hors `node_modules` et `.claude-plugin/types/`), en s'appuyant sur `claude/mods/CLAUDE.md` :

- **cassé** : un mod qui utilise une API changée ou retirée ;
- **contournement devenu inutile** : un bug corrigé pour lequel un mod, un commentaire `ponytail:` ou une ligne de la section « API
  constraints learned the hard way » de `claude/mods/CLAUDE.md` contourne ou documente encore l'ancien comportement ;
- **opportunité** : une nouvelle API qui simplifierait un mod existant (pas de nouvelle fonctionnalité spéculative).

Il répond par un tableau `Entrée | Mod (fichier:ligne) | Constat | Action proposée`, « rien à changer » pour une entrée sans
effet.

Ajoute une section `## Mods` après le résumé avec ce tableau tel quel. N'applique aucune modification : l'utilisateur trie d'abord.
