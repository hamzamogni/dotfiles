# dotfiles

Omarchy-style setup for macOS and Ubuntu, linked with [GNU Stow](https://www.gnu.org/software/stow/).

- [`shared/`](shared): configs both machines use. That's zsh, Neovim (LazyVim), Git, Ghostty, tmux, starship and btop.
- [`macos/`](macos): Mac-only packages and settings. Install with `macos/install.sh`. See [macos/README.md](macos/README.md).
- [`ubuntu/`](ubuntu): Ubuntu-only packages and GNOME settings. Install with `ubuntu/install.sh`. See [ubuntu/README.md](ubuntu/README.md).
- [`scripts/`](scripts): `link.sh` links packages for both installers. `test-link.sh` tests it in a throwaway home.
