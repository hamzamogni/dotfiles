# macOS dotfiles

A keyboard-driven, terminal-first setup for macOS:

- **Ghostty** terminal, **zsh**, **tmux** and **Neovim** (LazyVim)
- **AeroSpace** tiling window manager, with apps sent to fixed workspaces
- **Caps Lock remapped** to a "Super" key for window management (see [Caps Lock](#caps-lock))
- **Catppuccin** colors that follow the macOS light/dark appearance

## Install

```sh
./install.sh             # Homebrew packages + link dotfiles into ~
./install.sh --defaults  # ...and apply macOS settings from defaults.sh
```

Anything already in the way (like a default `~/.zprofile` or an existing `~/.config/<tool>` folder) is moved to `~/.dotfiles-backup/<date>/`.

After the first install:

1. **Open Karabiner-Elements** and approve everything macOS asks for (driver/system extension, Input Monitoring, keyboard type). Without this, Caps Lock is not remapped.
2. **Open AeroSpace** and give it Accessibility permission. It starts automatically at login after that.
3. Open a new Ghostty window to load the shell config, and start `nvim` once so LazyVim installs its plugins.
4. Set up containers: `podman machine init && podman machine start`.

## Layout

Every folder is a [stow](https://www.gnu.org/software/stow/) package that mirrors `~`:

| Package     | What                                                                                    |
| ----------- | --------------------------------------------------------------------------------------- |
| `zsh`       | Shell: aliases, functions, starship, zoxide, fzf, autosuggestions, syntax highlighting  |
| `ghostty`   | Terminal: Maple Mono, translucent, Catppuccin Latte/Mocha                               |
| `tmux`      | Multiplexer: `Ctrl+Space` prefix, Alt-based navigation, status bar on top               |
| `nvim`      | LazyVim with Catppuccin, transparency and auto light/dark                               |
| `starship`  | Minimal prompt                                                                          |
| `git`       | Git defaults, aliases and identity                                                      |
| `btop`      | System monitor, using terminal colors                                                   |
| `bin`       | Scripts in `~/.local/bin`: `tmux-sessionizer` (alias `ts`), `tmux-session-switch`       |
| `aerospace` | Tiling window manager: shortcuts and app-to-workspace rules                             |
| `karabiner` | Keyboard remapping: turns Caps Lock into Super / Escape                                 |

Each `~/.config/<tool>` is a symlink to the matching folder here, so editing a config in `~/.config` edits this repo, and apps that rewrite their own config (Karabiner) write here too.

To link a single package by hand, run from this folder: `stow -t ~ <package>` (`-R` to re-link, `-D` to unlink, `-n -v` for a dry run).

## Caps Lock

**Caps Lock does not behave like Caps Lock on this Mac.** Karabiner-Elements (installed by the Brewfile) remaps it, using the rules in `karabiner/.config/karabiner/karabiner.json`:

| You press                       | You get                                                                 |
| ------------------------------- | ----------------------------------------------------------------------- |
| **Hold** Caps Lock + another key | `Cmd+Ctrl` + that key. This is the **Super** key used by AeroSpace.    |
| **Tap** Caps Lock on its own    | `Esc`                                                                    |
| **Both Shift keys** together    | Real Caps Lock (toggles capital letters on/off)                          |

Why: macOS has no free "Super" key like Linux. `Cmd` belongs to apps and `Alt` (Option) belongs to tmux, so window management uses `Cmd+Ctrl`, which almost nothing else uses. Holding one key is easier than pressing two, and Caps Lock sits on the home row. Tapping it for `Esc` is a bonus for Neovim.

Things to know:

- In this README, **`Super+X` means hold Caps Lock and press X**. Pressing `Cmd+Ctrl+X` by hand does exactly the same thing.
- The remap only works while Karabiner-Elements is running and has its permissions.
- To turn it off temporarily: open Karabiner-Elements → Complex Modifications and disable the rules, or quit Karabiner-Elements. To remove it, delete the rules from `karabiner.json` or uninstall Karabiner-Elements.
- Karabiner writes some of its own settings into `karabiner.json` (like the keyboard type). Those changes are expected and fine to commit.

## Window management (AeroSpace)

[AeroSpace](https://nikitabobko.github.io/AeroSpace/guide) tiles windows automatically and groups them into **workspaces** (virtual desktops). All shortcuts use **Super** (hold Caps Lock). The config is `aerospace/.config/aerospace/aerospace.toml`, based on AeroSpace's default config. Saving it reloads AeroSpace automatically.

### Workspaces and app rules

New windows of these apps are moved to a fixed workspace:

| Workspace | Shortcut  | Apps                                     | Layout    |
| --------- | --------- | ---------------------------------------- | --------- |
| `1`       | `Super+1` | T3 Code, Codex (the ChatGPT app), Claude | Accordion |
| `2`       | `Super+2` | Zed                                      | Tiles     |
| `B`       | `Super+B` | Google Chrome (all profiles)             | Accordion |
| `M`       | `Super+M` | Spotify                                  | Tiles     |
| `N`       | `Super+N` | Obsidian                                 | Tiles     |
| `3`–`10`  | `Super+3..0` | Everything else (opens on the current workspace) | Tiles |

- **Tiles** places windows side by side. **Accordion** stacks windows on top of each other with a small edge of the others showing, like tabs. Move between them with `Super+H/J/K/L` (or arrows). Accordion is used for workspace 1 (AI apps) and B (one Chrome window per profile).
- Workspaces 1 and B always exist, even when empty, so they keep their accordion layout. Other workspaces disappear when empty, so `Super+Tab` only cycles through workspaces in use.
- System Settings, Activity Monitor and Bitwarden always float instead of tiling.

Limits of the rules:

- They only apply to **newly opened windows**. Windows already open when a rule was added stay where they are (move them with `Super+Shift+<number>`, or close and reopen them).
- Any window opened on workspace 1 or B joins the accordion. A window moved there with a shortcut joins it as long as the workspace is already in accordion.
- `Super+,` switches any workspace between tiles and accordion. On 1 and B, the next new window switches it back to accordion.

To add a rule, add an `[[on-window-detected]]` block in `aerospace.toml`. Find an app's ID with `aerospace list-apps`.

### Shortcuts

| Keys                                   | Action                                                    |
| -------------------------------------- | --------------------------------------------------------- |
| `Super+Enter`                          | New terminal (Ghostty) window                              |
| `Super+Shift+Enter` / `Super+Shift+B`  | New Chrome window, and go to workspace B                  |
| `Super+Shift+O`                        | Open Obsidian, and go to workspace N                      |
| `Super+Shift+M`                        | Open Spotify, and go to workspace M                       |
| `Super+Shift+F`                        | New Finder window                                         |
| `Super+Shift+/`                        | Bitwarden                                                 |
| `Super+W`                              | Close window                                              |
| `Super+H/J/K/L` or `Super+Arrows`      | Focus window left / down / up / right                     |
| `Super+Shift+H/J/K/L` or `+Arrows`     | Move window left / down / up / right                      |
| `Super+1..0`, `Super+B/M/N`            | Go to workspace                                           |
| `Super+Shift+1..0`                     | Move window to workspace (and follow it)                  |
| `Super+Shift+Alt+1..0`                 | Move window to workspace (stay where you are)             |
| `Super+Tab` / `Super+Shift+Tab`        | Next / previous workspace                                 |
| `Super+Alt+Tab`                        | Last used workspace                                       |
| `Super+F`                              | Fullscreen                                                |
| `Super+T`                              | Toggle floating                                           |
| `Super+/`                              | Toggle split direction                                    |
| `Super+,`                              | Toggle tiles / accordion                                  |
| `Super+-` / `Super+=`                  | Narrower / wider (`+Shift`: height, `+Alt`: smaller steps) |
| `Super+Shift+Alt+Arrows`               | Move workspace to another monitor                         |
| `Super+;`, then `Esc`                  | Reload config                                             |
| `Super+;`, then `R`                    | Reset the workspace layout                                |
| `Super+;`, then `F`                    | Toggle floating                                           |
| `Super+;`, then `Backspace`            | Close all other windows                                   |
| `Super+;`, then `H/J/K/L` or `Arrows`  | Join window with its neighbor                             |

`Super+Shift+3` and `Super+Shift+4` replace macOS's "screenshot to clipboard" shortcuts. Regular screenshots (`Cmd+Shift+3/4/5`) still work.

## Keyboard

Coming from Linux:

| Linux                    | Mac                                                  |
| ------------------------ | ---------------------------------------------------- |
| `Ctrl+C/V/W/T` in apps   | `Cmd+C/V/W/T`                                        |
| `Alt`                    | Left `Option` (right `Option` still types accents)   |
| `Ctrl` in the terminal   | `Control`                                            |
| `Super` (window manager) | Hold `Caps Lock` (see [Caps Lock](#caps-lock))       |
| `Esc`                    | `Esc`, or tap `Caps Lock`                            |
| `Caps Lock`              | Both `Shift` keys together                           |

### Shell

| Keys / command | Action                                              |
| -------------- | --------------------------------------------------- |
| `Alt+C`        | Pick a folder below the current one and `cd` to it  |
| `cd <name>`    | Jump to a frequently used folder (zoxide)           |
| `zi`           | Pick a frequently used folder with fzf              |
| `Ctrl+R`       | Search history with fzf                             |
| `ts`           | Pick a project and open it as a tmux session        |

### tmux

Prefix is `Ctrl+Space` (or `Ctrl+B`). Most actions don't need the prefix and use `Alt` (left Option):

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

## Light and dark mode

Ghostty switches between Catppuccin Latte (light) and Mocha (dark) with macOS. tmux, bat, fzf, eza, starship and btop use the terminal's colors, so they switch with it. Neovim switches itself through `auto-dark-mode.nvim`.

## Common changes

- **Add an app or CLI tool:** add a line to `Brewfile`, then `brew bundle --file=Brewfile`.
- **Send an app to a workspace:** add an `[[on-window-detected]]` rule in `aerospace.toml` (see [Workspaces and app rules](#workspaces-and-app-rules)).
- **Add a config:** create `<tool>/.config/<tool>/...`, add `<tool>` to `PACKAGES` in `install.sh`, then run `stow -t ~ <tool>`.
- **Change a macOS setting:** add a `defaults write` line to `defaults.sh`. To find a key, run `defaults read > before.txt`, change the setting in System Settings, run `defaults read > after.txt`, and diff the two files.
- **Machine-specific settings** that shouldn't be committed go in `~/.zshrc.local` and `~/.config/git/local` (e.g. a work git identity with `includeIf`).
