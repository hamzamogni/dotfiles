# Ubuntu dotfiles

The macOS setup, on Ubuntu GNOME. Ghostty, zsh, tmux and Neovim use the same configs as the Mac, from [`../shared`](../shared). This folder holds what only Ubuntu needs.

## Install

```sh
./install.sh              # apt packages + link dotfiles into ~ + switch to zsh
./install.sh --defaults   # ...and apply GNOME settings from defaults.sh
./install.sh --link-only  # only link dotfiles
```

The installer does the following:

1. Installs the apt packages in `packages.txt`, the Ubuntu counterpart of `../macos/Brewfile`.
2. Links `bat` and `fd` in `~/.local/bin` to Ubuntu's `batcat` and `fdfind`.
3. Installs [mise](https://mise.jdx.dev) into `~/.local/bin` and a stable Rust toolchain with `rustup`.
4. Installs the Maple Mono NF font into `~/.local/share/fonts`, after checking its SHA-256.
5. Links `../shared` and this folder's packages into `~`. Anything in the way moves to `~/.dotfiles-backup/<date>/`.
6. Installs LazyVim's plugins at the commits in `lazy-lock.json`, the same ones the Mac uses.
7. Switches your login shell to zsh. `chsh` asks for your password. Bash stays installed.

Log out and back in after the first install, so the GNOME session starts with zsh.

## Layout

| Package    | What                                                                       |
| ---------- | -------------------------------------------------------------------------- |
| `bin`      | `toggle-appearance`, which switches GNOME between light and dark mode      |
| `terminal` | `~/.config/xdg-terminals.list`, which makes Ghostty the default terminal    |

`defaults.sh` and `keyd/` are not stow packages. `defaults.sh` applies them with `--defaults`.

## Machine-specific settings

Keep these out of the repo:

- `~/.zshrc.local` for shell settings and secrets.
- `~/.config/git/local` for a work identity or other Git overrides.
- `~/.gitconfig` for settings tools write with `git config --global`, such as `gh auth setup-git`.
- `~/.profile` for environment variables the whole GNOME session needs. zsh login shells read it through `~/.zprofile`.
