# Terminal Tool

## Soft

- Zsh
- [vtop](https://github.com/MrRio/vtop)
- [neovim](https://neovim.io/) -> [nightly](https://github.com/neovim/neovim/releases)
- [desk](https://github.com/jamesob/desk)
- [pgcli](https://www.pgcli.com/)
- [mycli](https://www.mycli.net/)
- [http-prompt](https://github.com/eliangcs/http-prompt)
- [dry](https://moncho.github.io/dry/)
- [Fzf](https://github.com/junegunn/fzf)
- [shellcheck](https://github.com/koalaman/shellcheck)

### Powered by Rust

- [Rust](https://www.rust-lang.org/)
  - [rg](https://github.com/BurntSushi/ripgrep)
  - [fd](https://github.com/sharkdp/fd)
  - [exa](https://github.com/ogham/exa)

> `~/.cargo/.crates.toml`


## GIT
### Git credantial with gpg
https://grahamlopez.org/git/git_credentials.html

NB: in your gitconfig file, be sure to not have the field `username` under `[credential]` section

### `gh` github cli

extension: `gh extension install dlvhdr/gh-dash`

conf file: gh-config.yaml -> `~/.config/gh-dash/config.yml`

## Installation

### Symlink

| source          | destination                                 |
|-----------------|---------------------------------------------|
| bin folder      | a folder add in your PATH                   |
| zprofile        | $HOME                                       |
| zshrc           | $HOME                                       |
| profile         | $HOME                                       |
| gitconfig       | $HOME                                       |
| gitignore       | $HOME                                       |
| wuzz            | $HOME                                       |
| vifm            | $HOME                                       |
| tmux            | $HOME                                       |
| tmux/tmux.conf  | $HOME                                       |
| nvim            | $XDG_CONFIG_HOME                            |
| pgcli/config    | $XDG_CONFIG_HOME/pgcli                      |
| efm-config.yaml | $XDG_CONFIG_HOME/efm-langserver/config.yaml |
| kitty.conf      | $XDG_CONFIG_HOME/kitty/kitty.conf           |
|-----------------|---------------------------------------------|


## Install

> git submodules init
