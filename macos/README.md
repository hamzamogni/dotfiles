# macOS dotfiles

Omarchy's terminal setup (Ghostty, zsh, tmux, Neovim) on macOS, with Catppuccin that follows the system light/dark appearance.

## Install

```sh
./install.sh             # Homebrew packages + link dotfiles into ~
./install.sh --defaults  # ...and apply macOS settings from defaults.sh
```

Anything already in the way (like a default `~/.zprofile`) is moved to `~/.dotfiles-backup/`.

## Layout

Every folder is a [stow](https://www.gnu.org/software/stow/) package that mirrors `~`:

| Package    | What                                                                          |
| ---------- | ----------------------------------------------------------------------------- |
| `zsh`      | Omarchy's bash config ported to zsh, plus autosuggestions and syntax highlighting |
| `ghostty`  | Terminal: Maple Mono, translucent, Catppuccin Latte/Mocha                     |
| `tmux`     | Omarchy's tmux config                                                         |
| `nvim`     | LazyVim with Omarchy's tweaks                                                 |
| `starship` | Omarchy's prompt                                                              |
| `git`      | Omarchy's git defaults plus your identity                                     |
| `bin`      | Scripts in `~/.local/bin`: `tmux-sessionizer` (alias `ts`), `tmux-session-switch` |
| `btop`     | Omarchy's btop config, using terminal colors                                  |

Files are symlinked, so editing `~/.config/...` edits this repo.

## Common changes

- **Add an app or CLI tool:** add a line to `Brewfile`, then `brew bundle --file=Brewfile`.
- **Add a config:** create `<tool>/.config/<tool>/...`, add `<tool>` to `PACKAGES` in `install.sh`, then run `stow <tool>`.
- **Change a macOS setting:** add a `defaults write` line to `defaults.sh`. To find a key, run `defaults read > before.txt`, change the setting in System Settings, run `defaults read > after.txt`, and diff the two files.
- **Machine-specific settings** that shouldn't be committed go in `~/.zshrc.local` and `~/.config/git/local` (e.g. a work git identity with `includeIf`).

## Light and dark mode

Ghostty switches between Catppuccin Latte and Mocha with macOS. tmux, bat, fzf, eza, starship and btop use the terminal's colors, so they switch with it. Neovim switches itself through `auto-dark-mode.nvim`.

## Keyboard

| Linux / Omarchy                 | Mac                                         |
| ------------------------------- | ------------------------------------------- |
| `Ctrl+C/V/W/T` in apps          | `Cmd+C/V/W/T`                               |
| `Alt`                           | Left `Option` (right `Option` types accents) |
| `Ctrl` in the terminal          | `Control`                                   |
| `Super` (window manager)        | `Cmd+Ctrl`, reserved for AeroSpace          |

tmux (prefix `Ctrl+Space`, or `Ctrl+B`):

| Keys                         | Action                              |
| ---------------------------- | ----------------------------------- |
| `Alt+Enter` / `Alt+Shift+Enter` | Split pane down / right          |
| `Alt+Escape`                 | Close pane                          |
| `Ctrl+Alt+Arrows`            | Move between panes                  |
| `Ctrl+Alt+Shift+Arrows`      | Resize pane                         |
| `Alt+1..9`                   | Go to window                        |
| `Alt+Left/Right`             | Previous / next window              |
| `Alt+Up/Down`                | Previous / next session             |
| `prefix f`                   | Pick a project with fzf, open it as a session |
| `prefix s`                   | Switch session with fzf (with preview) |
| `prefix ?`                   | Show all keybindings                |
