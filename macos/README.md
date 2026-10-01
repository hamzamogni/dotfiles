# macOS dotfiles

A terminal-first setup (Ghostty, zsh, tmux, Neovim) with Catppuccin that follows the system light/dark appearance.

## Install

```sh
./install.sh             # Homebrew packages + link dotfiles into ~
./install.sh --defaults  # ...and apply macOS settings from defaults.sh
```

Anything already in the way (like a default `~/.zprofile`) is moved to `~/.dotfiles-backup/`.

## Layout

Every folder is a [stow](https://www.gnu.org/software/stow/) package that mirrors `~`:

| Package    | What                                                                               |
| ---------- | ---------------------------------------------------------------------------------- |
| `zsh`      | Shell: aliases, functions, starship, zoxide, fzf, autosuggestions, syntax highlighting |
| `ghostty`  | Terminal: Maple Mono, translucent, Catppuccin Latte/Mocha                          |
| `tmux`     | Multiplexer: `Ctrl+Space` prefix, Alt-based navigation, status bar on top          |
| `nvim`     | LazyVim with Catppuccin, transparency and auto light/dark                          |
| `starship` | Minimal prompt                                                                     |
| `git`      | Git defaults, aliases and identity                                                 |
| `btop`     | System monitor, using terminal colors                                              |
| `bin`      | Scripts in `~/.local/bin`: `tmux-sessionizer` (alias `ts`), `tmux-session-switch`  |
| `aerospace`| Tiling window manager, driven by `Super` (hold Caps Lock)                          |
| `karabiner`| Caps Lock: hold = `Super` (sends `Cmd+Ctrl`), tap = `Esc`; both Shifts = Caps Lock |

Files are symlinked, so editing `~/.config/...` edits this repo.

## Common changes

- **Add an app or CLI tool:** add a line to `Brewfile`, then `brew bundle --file=Brewfile`.
- **Add a config:** create `<tool>/.config/<tool>/...`, add `<tool>` to `PACKAGES` in `install.sh`, then run `stow <tool>`.
- **Change a macOS setting:** add a `defaults write` line to `defaults.sh`. To find a key, run `defaults read > before.txt`, change the setting in System Settings, run `defaults read > after.txt`, and diff the two files.
- **Machine-specific settings** that shouldn't be committed go in `~/.zshrc.local` and `~/.config/git/local` (e.g. a work git identity with `includeIf`).

## Light and dark mode

Ghostty switches between Catppuccin Latte and Mocha with macOS. tmux, bat, fzf, eza, starship and btop use the terminal's colors, so they switch with it. Neovim switches itself through `auto-dark-mode.nvim`.

## Keyboard

| Linux                    | Mac                                          |
| ------------------------ | -------------------------------------------- |
| `Ctrl+C/V/W/T` in apps   | `Cmd+C/V/W/T`                                |
| `Alt`                    | Left `Option` (right `Option` types accents) |
| `Ctrl` in the terminal   | `Control`                                    |
| `Super` (window manager) | Hold `Caps Lock` (sends `Cmd+Ctrl`)          |
| `Esc`                    | Tap `Caps Lock` (or `Esc`)                   |
| `Caps Lock`              | Both `Shift` keys together                   |

Windows (AeroSpace):

| Keys                            | Action                                  |
| ------------------------------- | --------------------------------------- |
| `Super+Enter`                   | New terminal window                     |
| `Super+Shift+Enter` / `+B`      | New browser window                      |
| `Super+Shift+F/O/M`             | Finder / Obsidian / Spotify             |
| `Super+Shift+/`                 | Bitwarden                               |
| `Super+W`                       | Close window                            |
| `Super+Arrows`                  | Focus window                            |
| `Super+Shift+Arrows`            | Move window                             |
| `Super+1..0`                    | Go to workspace 1..10                   |
| `Super+Shift+1..0`              | Move window to workspace (and follow)   |
| `Super+Shift+Alt+1..0`          | Move window to workspace (stay)         |
| `Super+Tab` / `+Shift+Tab`      | Next / previous workspace               |
| `Super+Alt+Tab`                 | Last used workspace                     |
| `Super+F`                       | Fullscreen                              |
| `Super+T`                       | Toggle floating                         |
| `Super+J`                       | Toggle split direction                  |
| `Super+L`                       | Toggle tiles / accordion layout         |
| `Super+-` / `=`                 | Narrower / wider (`+Shift`: height, `+Alt`: smaller steps) |
| `Super+Shift+Alt+Arrows`        | Move workspace to another monitor       |
| `Super+;` then `Esc` / `R` / `Backspace` / `Arrows` | Reload config / reset layout / close other windows / join with neighbor |

Shell:

| Keys / command  | Action                                           |
| --------------- | ------------------------------------------------ |
| `Alt+C`         | Pick a folder below the current one and `cd` to it |
| `cd <name>`     | Jump to a frequently used folder (zoxide)        |
| `zi`            | Pick a frequently used folder with fzf           |
| `Ctrl+R`        | Search history with fzf                          |
| `ts`            | Pick a project and open it as a tmux session     |

tmux (prefix `Ctrl+Space`, or `Ctrl+B`):

| Keys                            | Action                                        |
| ------------------------------- | --------------------------------------------- |
| `Alt+Enter` / `Alt+Shift+Enter` | Split pane down / right                       |
| `Alt+Escape`                    | Close pane                                    |
| `Ctrl+Alt+Arrows`               | Move between panes                            |
| `Ctrl+Alt+Shift+Arrows`         | Resize pane                                   |
| `Alt+1..9`                      | Go to window                                  |
| `Alt+Left/Right`                | Previous / next window                        |
| `Alt+Up/Down`                   | Previous / next session                       |
| `prefix f`                      | Pick a project with fzf, open it as a session |
| `prefix s`                      | Switch session with fzf (with preview)        |
| `prefix q`                      | Reload tmux config                            |
| `prefix ?`                      | Show all keybindings                          |
