# Ubuntu profile plan

This plan gives a coding agent the steps to add an Ubuntu desktop profile to `hamzamogni/dotfiles`. The profile matches the macOS setup, which is itself a port of Omarchy. The Mac and Ubuntu machines share one copy of the zsh, Neovim, Git, Ghostty, tmux, starship and btop configs. Each OS keeps a small profile for what can't be shared: the package list, window management, keyboard remapping and system settings.

Prepared 13 October 2026, against `master` at `0fad722`. This plan replaces an earlier draft that targeted a headless Ubuntu host reached through Herdr and Tailscale SSH. That draft was out of date. The Ubuntu machine runs a GNOME desktop, and Herdr is out of scope for now.

## Rules for the implementing agent

- Keep GNU Stow and plain Bash. Don't add chezmoi, Ansible, Nix or a templating layer.
- Keep one copy of every shared config. Don't fork a file into Mac and Ubuntu versions when a guard inside the file works.
- Don't install Omarchy or Hyprland. The goal is the Omarchy experience on stock Ubuntu GNOME.
- Use the Ubuntu archive for every package it carries. Download from upstream only for the two tools apt lacks, which are mise and the Maple Mono NF font.
- Make one commit per section below, and run that section's check before starting the next one.
- Don't run `macos/install.sh` on a Mac yourself. Mark Mac checks as pending for the owner to run.

## Facts this plan relies on

These were measured on the Ubuntu machine on 13 October 2026.

| Fact | Value |
| --- | --- |
| OS | Ubuntu 26.04.1 LTS, x86_64, GNOME 50 on Wayland |
| User | `hamza`, login shell `/bin/bash` |
| Already installed | `nvim` 0.11.6 (apt), `git` 2.53, `tailscale` 1.104.1, `openssh-server`, `curl` |
| Missing | `zsh`, `stow`, `fzf`, `mise`, `git-lfs`, `ghostty` |
| Home targets | `~/.zshrc`, `~/.config/nvim` and `~/.config/git` don't exist. `~/.gitconfig` exists and holds machine-local settings. `~/.profile` holds local exports (`TMPDIR`, `CLAUDE_CODE_TMPDIR`, `FIZZY_NO_KEYRING`). |
| GNOME state | `color-scheme` is `prefer-dark`, workspaces are dynamic, `xkb-options` is empty, and Ubuntu Dock's Super+number hotkeys are on. The `tiling-assistant@ubuntu.com` extension is enabled. |
| t3Code worktrees | `~/.t3/worktrees` |

apt has a recent enough version of every Brewfile CLI tool. That includes `neovim` 0.11.6, `fzf` 0.67, `ghostty` 1.3.0, `starship`, `eza`, `zoxide`, `bat`, `fd-find`, `ripgrep`, `lazygit`, `gum`, `btop`, `tmux`, `git-lfs`, `gh`, `jq`, `fastfetch`, `tree-sitter-cli`, `podman`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `wl-clipboard` and `keyd`. apt does not carry `mise`, `lazydocker` or Maple Mono NF.

## Target layout

```text
shared/                      Stowed on both machines
  zsh/  nvim/  git/  starship/  tmux/  btop/  ghostty/
  bin/.local/bin/{tmux-sessionizer,tmux-session-switch}
macos/                       Mac-only
  install.sh  Brewfile  defaults.sh  README.md
  aerospace/  karabiner/
  bin/.local/bin/toggle-appearance
ubuntu/                      Ubuntu-only
  install.sh  packages.txt  defaults.sh  README.md
  keyd/  (system file, copied by defaults.sh, not stowed)
  bin/.local/bin/toggle-appearance
scripts/
  link.sh                    Backup-and-stow logic both installers call
  test-link.sh               Runs link.sh twice in a throwaway HOME
```

`linux/` is deleted.

## 1. Delete the old Linux profile

`linux/` holds pre-Omarchy i3, X11, Packer-Neovim and Oh My Zsh configs. Nothing in the new profile uses it. Git history keeps it if you ever need a file back.

1. Run `git rm -r linux`.
2. Remove the `linux/` line from `README.md`.

**Check.** `git ls-files linux` prints nothing. `grep -rn 'linux/' --exclude-dir=.git .` matches only this plan.

## 2. Move the portable packages into `shared/`

1. Run `git mv` to move `zsh`, `nvim`, `git`, `starship`, `tmux`, `btop` and `ghostty` from `macos/` to `shared/`.
2. Create `shared/bin/.local/bin/`. Move `tmux-sessionizer` and `tmux-session-switch` into it. Leave `toggle-appearance` in `macos/bin`.
3. Move the backup and stow loop out of `macos/install.sh` into `scripts/link.sh`. It takes a stow directory and a list of packages. It keeps the existing `~/.dotfiles-backup/<timestamp>/` backups.
4. In `scripts/link.sh`, pass `--no-folding` for the `git` and `bin` packages. Keep folding for the rest, because Karabiner and similar apps rewrite their whole config folder.
5. Before stowing, have `scripts/link.sh` delete dangling symlinks in `$HOME` whose target points into this repo. The Mac's existing links point at `macos/<package>`, and they dangle after the move.
6. Add a `--link-only` flag to `macos/install.sh` that skips Homebrew. It calls `scripts/link.sh shared ...` and then `scripts/link.sh macos aerospace karabiner bin`.
7. Write `scripts/test-link.sh`. It creates a temporary `HOME`, runs `scripts/link.sh shared <all shared packages>` twice, and asserts three things:
   - The second run creates no backup directory.
   - `~/.config/git` is a real directory and `~/.config/git/config` is a symlink.
   - A pre-existing `~/.zshrc` was moved to the backup folder.

**Why `--no-folding` for `git`.** Today `~/.config/git` is one symlink to the repo. So `~/.config/git/local`, which holds private identity overrides, sits inside the repo checkout as an untracked file. The `[filter "lfs"]` block added in `0fad722` probably got into the shared config the same way, because `git lfs install` writes to the global config through the symlink. That cause is a guess.

**Check.** `scripts/test-link.sh` passes on Ubuntu. On the Mac, the owner runs `macos/install.sh --link-only`, then `git status`, which must stay clean. The Mac check is pending until the owner runs it.

## 3. Make the shared shell portable

Each change below is a guard inside the shared file. Don't create per-OS copies.

1. In `shared/zsh/.zprofile`, run `brew shellenv` only when `/opt/homebrew/bin/brew` or `/usr/local/bin/brew` exists.
2. In the same file, source `~/.profile` under `emulate sh` when it exists. On Ubuntu, GDM starts the GNOME session through the login shell. A zsh login shell reads `.zprofile` but not `~/.profile`, so the local exports there would otherwise disappear.
3. Move the Android SDK lines and the duplicate `~/.local/bin` line out of `shared/zsh/.zshrc`. The Android paths are Mac machine settings and belong in the Mac's `~/.zshrc.local`. `envs.zsh` already adds `~/.local/bin`. Tell the owner to copy the Android lines into the Mac's `~/.zshrc.local` before pulling.
4. In `init.zsh`, look for `zsh-autosuggestions` and `zsh-syntax-highlighting` under `$HOMEBREW_PREFIX/share` and `/usr/share`. Load the first match.
5. In `shell.zsh`, add the Homebrew `site-functions` directory to `fpath` only when `HOMEBREW_PREFIX` is set.
6. Rewrite `sff` in `aliases.zsh` with a zsh glob, `print -rl -- **/*(.om)`, instead of BSD `stat -f`. It lists files newest first on both systems.
7. Add `bat` and `fd` aliases in `aliases.zsh` that point at `batcat` and `fdfind` when the short names don't exist. Ubuntu installs both tools under the long names.
8. Put `~/.local/bin` and `~/.local/share/mise/shims` on `PATH` in `.zshenv`. Non-interactive commands such as `ssh host 'codex ...'` then find mise-managed tools without `mise activate`.
9. In `tmux-sessionizer` and `tmux-session-switch`, delete the line that prepends `/opt/homebrew/bin` to `PATH`.

**Check.** On Ubuntu with zsh installed, run each of these:
- `zsh -n` on every file under `shared/zsh` prints nothing.
- `zsh -ic exit` prints nothing to stderr.
- `zsh -c 'command -v nvim git mise'` resolves all three.
- `ssh localhost true` prints nothing.

## 4. Write the Ubuntu installer

1. Write `ubuntu/packages.txt` with one apt package per line. Mirror the Brewfile's CLI tools from the facts table, and add `zsh`, `stow`, `git-lfs`, `wl-clipboard`, `ghostty`, `build-essential`, `unzip` and `fontconfig`. Leave out GUI apps such as Zed, Obsidian, Slack and Spotify. Those are personal installs, not dotfiles.
2. Write `ubuntu/install.sh` in the same shape as `macos/install.sh`. It does these steps in order:
   1. It exits unless `/etc/os-release` says `ID=ubuntu`.
   2. It runs `sudo apt-get install -y` on `packages.txt`. Any failure stops the script.
   3. It installs mise with the official installer into `~/.local/bin` when `mise` is missing.
   4. It installs Maple Mono NF into `~/.local/share/fonts` from a pinned GitHub release, verifies the release checksum, and runs `fc-cache`. It skips this step when `fc-list` already lists the font.
   5. It runs `scripts/link.sh shared ...` and then `scripts/link.sh ubuntu bin`.
   6. It runs `chsh -s "$(command -v zsh)"` when the login shell isn't zsh. Bash stays installed as a fallback.
   7. It runs `ubuntu/defaults.sh` only with `--defaults`, which is the same flag the Mac installer uses.
3. Support `--link-only`, which skips steps 2 to 4 and step 6.
4. Write `ubuntu/README.md`, covering install, the flags, and where local overrides go. Local overrides are `~/.zshrc.local`, `~/.config/git/local`, `~/.gitconfig` and `~/.profile`.

**Check.** `HOME=$(mktemp -d) ubuntu/install.sh --link-only` succeeds. Then run `ubuntu/install.sh` for real on this machine. The stowed home targets don't exist yet, so the run should back up nothing. After it finishes, log out and back in. Then confirm three things:
- Ghostty opens zsh with the starship prompt in Maple Mono NF.
- `nvim` installs plugins from `lazy-lock.json` with no errors in `:checkhealth`.
- `git config --show-origin user.email` reports `~/.config/git/config` or a local override.

## 5. Make `ga` and `gd` safe

`gd` force-removes a worktree and force-deletes its branch. It guesses the branch name from the folder name. That loses uncommitted work and can delete the wrong branch, including in t3Code checkouts.

1. In `ga`, stop if `git worktree add` fails, and remove the automatic `mise trust`.
2. In `gd`, read the branch from `git branch --show-current` instead of the folder name.
3. In `gd`, refuse to run when the path is under `~/.t3/worktrees` or when `git status --porcelain` is not empty.
4. In `gd`, drop `--force` from `git worktree remove` and change `git branch -D` to `git branch -d`.

**Check.** In a scratch repo, `gd` refuses a dirty worktree and refuses a branch with unmerged commits. It removes a clean, merged one.

## 6. Make GNOME feel like Omarchy

`ubuntu/defaults.sh` is the Ubuntu counterpart to `macos/defaults.sh`. It is a list of `gsettings set` lines, safe to re-run, and runs only with `--defaults`.

1. Use a fixed set of four workspaces. Set `org.gnome.mutter dynamic-workspaces` to `false` and `num-workspaces` to `4`.
2. Bind Super+1 to Super+4 to switch to a workspace, and Super+Shift+1 to Super+Shift+4 to move the window there. Turn off Ubuntu Dock's `hot-keys` first, because it owns Super+number.
3. Bind Super+Return to launch Ghostty, and Super+Q to close the window. These match Omarchy and the Mac's AeroSpace bindings.
4. Set fast key repeat with a short `delay` and `repeat-interval` under `org.gnome.desktop.peripherals.keyboard`, matching `macos/defaults.sh`.
5. Map Caps Lock to Escape on tap and Super on hold with `keyd`, which matches the Mac's Karabiner rule. GNOME's `xkb-options` can't do tap and hold on one key. `defaults.sh` copies `ubuntu/keyd/default.conf` to `/etc/keyd/` and enables the `keyd` service. This is the only system file the profile touches.
6. Write `ubuntu/bin/.local/bin/toggle-appearance`. It switches `org.gnome.desktop.interface color-scheme` between `prefer-dark` and `default`. Ghostty's `theme = light:...,dark:...` and Neovim's `auto-dark-mode.nvim` both follow that setting on GNOME. That is a guess until the check below confirms it.
7. Bind Super+Shift+T to `toggle-appearance`.

**Check.** After `ubuntu/install.sh --defaults` and a re-login, confirm each behavior by hand.
- Super+2 switches workspace.
- Super+Return opens Ghostty.
- Holding Caps Lock with a number key acts as Super, and tapping it sends Escape in Neovim.
- `toggle-appearance` flips GNOME, an open Ghostty window and an open Neovim between Mocha and Latte without a restart.

## Open decisions for the owner

- **Tiling.** Omarchy and AeroSpace tile windows automatically. GNOME doesn't. Ubuntu's built-in `tiling-assistant` gives keyboard snapping but not automatic tiling. A tiling extension such as Forge or PaperWM would match better, but extensions break across GNOME releases. My recommendation is to live with sections 1 to 6 first and decide after a week.
- **Herdr and remote access from the Mac.** Out of scope for now. If it comes back, test that a remote Neovim process survives a disconnect before adding any repo config. Plain OpenSSH over the tailnet is enough for both Herdr and t3Code. Tailscale SSH adds policy work without a clear need.

## Out of scope

- Herdr, Tailscale SSH policy and a `worktree-review` helper.
- GUI apps that aren't configured by dotfiles.
- CI. `scripts/test-link.sh` runs locally.
- A dry-run mode. `--link-only` with a throwaway `HOME` covers the same need.
- Manifest-based rollback. `git revert` plus the timestamped backups cover it.
