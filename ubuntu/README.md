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
| `ghostty`  | `os.ghostty`, which makes `Caps Lock+A` send the tmux prefix              |
| `tmux`     | `os.conf`, which makes tmux orange (Catppuccin Peach) instead of blue      |

`defaults.sh` and `keyd/` are not stow packages. `defaults.sh` applies them with `--defaults`.

## Machine-specific settings

Keep these out of the repo:

- `~/.zshrc.local` for shell settings and secrets.
- `~/.config/git/local` for a work identity or other Git overrides.
- `~/.gitconfig` for settings tools write with `git config --global`, such as `gh auth setup-git`.
- `~/.profile` for environment variables the whole GNOME session needs. zsh login shells read it through `~/.zprofile`.

## GNOME settings

`./install.sh --defaults` runs `defaults.sh`. It sets up Caps Lock like on the Mac and gives GNOME the same main shortcuts as AeroSpace. It doesn't add a tiling extension.

### Caps Lock

keyd remaps Caps Lock using `keyd/default.conf`, which `defaults.sh` copies to `/etc/keyd/`. This is the only system file the profile changes.

| You press                        | You get     |
| -------------------------------- | ----------- |
| **Hold** Caps Lock + another key | `Super` + that key |
| **Tap** Caps Lock on its own     | `Esc`       |
| **Both Shift keys** together     | Real Caps Lock |

To turn it off, run `sudo systemctl disable --now keyd`.

### Shortcuts

| Keys                    | Action                                  |
| ----------------------- | --------------------------------------- |
| `Super+Enter`           | New terminal (Ghostty) window            |
| `Super+Shift+F`         | New Files window                         |
| `Super+Shift+T`         | Toggle light / dark mode                 |
| `Super+W`               | Close window                             |
| `Super+F`               | Fullscreen                               |
| `Super+1..5`            | Go to workspace                          |
| `Super+Shift+1..5`      | Move window to workspace                 |
| `Super+Tab` / `Super+Shift+Tab` | Next / previous workspace        |
| `Alt+Tab`               | Switch windows (unchanged)               |
| `Caps Lock+A`           | tmux prefix, same as `Ctrl+Space`        |

`defaults.sh` also sets five fixed workspaces, fast key repeat and tap to click. It turns off Ubuntu Dock's `Super+<number>` app shortcuts and GNOME's `Super+A` app grid, which would clash with the workspace shortcuts and the tmux prefix. Ghostty, Neovim and the CLI tools follow GNOME's light and dark mode.
