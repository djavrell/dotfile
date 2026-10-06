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
