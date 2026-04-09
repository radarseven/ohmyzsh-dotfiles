# Dotfiles

macOS dotfiles managed with GNU Stow. Apple Silicon (arm64), Homebrew at /opt/homebrew.

## Structure

Stow packages (symlinked to ~/):
- `shell/` — ZSH config (.zshrc, .mix-aliases, .mix-exports, .mix-path, .hushlogin, .screenrc)
- `git/` — Git config (.gitconfig, .global-gitignore)
- `vim/` — Vim config (.vimrc, .gvimrc, .vim/)
- `wget/` — wget config (.wgetrc)
- `bin/` — Custom scripts (~/bin/)
- `config/` — XDG config (~/.config/starship.toml)

Non-stowed files at repo root:
- `Brewfile` — Homebrew packages (`brew bundle` to install)
- `bootstrap.sh` — Stow all packages to ~/
- `.osx` — macOS system defaults (run manually)

## Conventions

- Shell config is modular: .zshrc sources .mix-{path,exports,aliases,extra}
- `.mix-extra` is private (not in repo) — used for secrets and local overrides
- Aliases go in `.mix-aliases`, PATH changes in `.mix-path`, env vars in `.mix-exports`
- Stow a single package: `stow -R -d . -t ~ <package>`
- Test changes: `source ~/.zshrc`

## Branches

- `enterprise` — main branch (modernized, Stow-based)
- `beam-me-up-scotty` — legacy snapshot (rsync-based, pre-modernization)

## Bootstrap

```bash
./bootstrap.sh    # Symlink all packages to ~/
brew bundle        # Install Homebrew packages
source ~/.zshrc    # Reload shell
```
