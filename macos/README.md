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
| `bin`       | Scripts in `~/.local/bin`: `tmux-sessionizer` (alias `ts`), `tmux-session-switch`, `toggle-appearance` |
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

| Workspace | Shortcut     | Apps                                     | Layout    | Monitor  |
| --------- | ------------ | ---------------------------------------- | --------- | -------- |
| `1`       | `Super+1`    | T3 Code, Codex (the ChatGPT app), Claude | Accordion | Main     |
| `2`       | `Super+2`    | Zed                                      | Tiles     | Main     |
| `7`       | `Super+7`    | Microsoft Outlook, Microsoft Teams       | Accordion | Laptop   |
| `8`       | `Super+8`    | Proton Mail                              | Tiles     | Main     |
| `B`       | `Super+B`    | Google Chrome (all profiles)             | Accordion | Main     |
| `C`       | `Super+C`    | Slack, WhatsApp                          | Accordion | Laptop   |
| `M`       | `Super+M`    | Spotify                                  | Tiles     | Laptop   |
| `N`       | `Super+N`    | Obsidian                                 | Tiles     | Laptop   |
| others    | `Super+3..0` | Everything else (opens on the current workspace) | Tiles | Main |

"Main" is the display marked as Main in System Settings → Displays (the external monitor when one is connected). See [Multiple monitors](#multiple-monitors).

- **Tiles** places windows side by side. **Accordion** stacks windows on top of each other with a small edge of the others showing, like tabs. Move between them with `Super+H/J/K/L` (or arrows). Accordion is used for workspace 1 (AI apps), 7 (Outlook and Teams), B (one Chrome window per profile) and C (chat apps).
- Workspaces 1, 7, B and C are set to accordion when AeroSpace starts (`after-startup-command` in `aerospace.toml`). They always exist, even when empty, so they keep that layout. Other workspaces disappear when empty, so `Super+Tab` only cycles through workspaces in use.
- System Settings, Activity Monitor and Bitwarden always float instead of tiling.

Limits of the rules:

- They only apply to **newly opened windows**. Windows already open when a rule was added stay where they are (move them with `Super+Shift+<workspace>`, e.g. `Super+Shift+C`, or close and reopen them).
- Any window opened on or moved to workspace 1, 7, B or C joins the accordion.
- `Super+,` switches any workspace between tiles and accordion. A switch stays until you change it back or AeroSpace restarts, which resets 1, 7, B and C to accordion.
- To make another workspace accordion by default, add it to both `after-startup-command` and `persistent-workspaces`. Changes to `after-startup-command` take effect the next time AeroSpace starts.

To add a rule, add an `[[on-window-detected]]` block in `aerospace.toml`. Find an app's ID with `aerospace list-apps`.

### Multiple monitors

- Workspaces are shared between monitors. Each monitor shows one workspace at a time, and every workspace belongs to one monitor.
- Going to a workspace (e.g. `Super+B`) shows it on the monitor it belongs to and focuses that monitor. It does not open on whichever screen you're looking at.
- Workspaces are pinned to monitors in `[workspace-to-monitor-force-assignment]` in `aerospace.toml` (see the Monitor column above):
  - **Main monitor:** 1, 2, B, plus every workspace not listed (3–6, 8–10).
  - **Laptop screen:** 7, C, M, N.
  - With only one screen connected (laptop alone, or lid closed on an external monitor), everything falls back to it.
- Pinned workspaces can't be moved with `Super+Shift+Alt+Arrows`; change the pinning in the config instead. Unpinned ones can.
- `Super+.` focuses the other monitor. `Super+Shift+.` sends the focused window to the other monitor (to whatever workspace is visible there).

macOS settings this relies on (applied by `defaults.sh`, as recommended by AeroSpace):

- **"Displays have separate Spaces" is off.** With it on, macOS has focus and performance bugs with AeroSpace across monitors. Takes effect after logging out and back in. Side effect: a full-screen app (macOS green button) blacks out the other monitor; use `Super+F` (AeroSpace fullscreen) instead.
- **Mission Control groups windows by app.** Otherwise it shows tiny thumbnails, because AeroSpace parks hidden windows in a screen corner.

Also arrange your monitors (System Settings → Displays → Arrange) so **every screen has a free bottom-left or bottom-right corner**: that's where AeroSpace parks hidden windows. With the laptop centered below the external monitor, all corners are free.

### Shortcuts

| Keys                                   | Action                                                    |
| -------------------------------------- | --------------------------------------------------------- |
| `Super+Enter`                          | New terminal (Ghostty) window                              |
| `Super+Shift+Enter`                    | New Chrome window, and go to workspace B                  |
| `Super+Shift+O`                        | Open Obsidian, and go to workspace N                      |
| `Super+Shift+E`                        | Open Zed, and go to workspace 2                           |
| `Super+Shift+S`                        | Open Spotify, and go to workspace M                       |
| `Super+Shift+F`                        | New Finder window                                         |
| `Super+Shift+/`                        | Bitwarden                                                 |
| `Super+Shift+T`                        | Toggle light / dark mode                                  |
| `Super+W`                              | Close window                                              |
| `Super+H/J/K/L` or `Super+Arrows`      | Focus window left / down / up / right                     |
| `Super+Shift+H/J/K/L` or `+Arrows`     | Move window left / down / up / right                      |
| `Super+1..0`, `Super+B/C/M/N`          | Go to workspace                                           |
| `Super+Shift+1..0`, `Super+Shift+B/C/M/N` | Move window to workspace (and follow it)               |
| `Super+Shift+Alt+1..0`, `Super+Shift+Alt+B/C/M/N` | Move window to workspace (stay where you are)  |
| `Super+Tab` / `Super+Shift+Tab`        | Next / previous workspace                                 |
| `Super+Alt+Tab`                        | Last used workspace                                       |
| `Super+F`                              | Fullscreen                                                |
| `Super+T`                              | Toggle floating                                           |
| `Super+/`                              | Toggle split direction                                    |
| `Super+,`                              | Toggle tiles / accordion                                  |
| `Super+-` / `Super+=`                  | Narrower / wider (`+Shift`: height, `+Alt`: smaller steps) |
| `Super+Shift+Alt+Arrows`               | Move workspace to another monitor                         |
| `Super+.`                              | Focus the other monitor                                   |
| `Super+Shift+.`                        | Move window to the other monitor                          |
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

To switch by hand, press `Super+Shift+T` or run `toggle-appearance`. This sets macOS to a fixed Light or Dark appearance; to go back to switching automatically with the time of day, choose **Auto** in System Settings → Appearance.

## Common changes

- **Add an app or CLI tool:** add a line to `Brewfile`, then `brew bundle --file=Brewfile`.
- **Send an app to a workspace:** add an `[[on-window-detected]]` rule in `aerospace.toml` (see [Workspaces and app rules](#workspaces-and-app-rules)).
- **Add a config:** create `<tool>/.config/<tool>/...`, add `<tool>` to `PACKAGES` in `install.sh`, then run `stow -t ~ <tool>`.
- **Change a macOS setting:** add a `defaults write` line to `defaults.sh`. To find a key, run `defaults read > before.txt`, change the setting in System Settings, run `defaults read > after.txt`, and diff the two files.
- **Machine-specific settings** that shouldn't be committed go in `~/.zshrc.local` and `~/.config/git/local` (e.g. a work git identity with `includeIf`).
