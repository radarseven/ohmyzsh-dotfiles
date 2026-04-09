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

- Shell config is modular: .zshrc sources .mix-{path,exports,aliases} before oh-my-zsh, then .mix-extra after
- `.mix-extra` is private (not in repo) — used for secrets, machine-specific tools (Herd, Kiro, OpenClaw), and anything that needs `compdef`
- Aliases go in `.mix-aliases`, PATH changes in `.mix-path`, env vars in `.mix-exports`
- Stow a single package: `stow -R -d . -t ~ <package>`
- Test changes: `source ~/.zshrc`

## Handling tool auto-injection

Since ~/.zshrc is a symlink, tools that auto-inject lines (Herd, Kiro, etc.) will modify the repo file. When this happens:
1. Check what changed: `git diff shell/.zshrc`
2. Move the injected lines to `~/.mix-extra`
3. Restore: `git checkout -- shell/.zshrc`

Always prefer `.mix-extra` for machine-specific tooling. Keep the committed files portable and clean.

## Branches

- `enterprise` — main branch (modernized, Stow-based)
- `beam-me-up-scotty` — legacy snapshot (rsync-based, pre-modernization)

## Bootstrap

```bash
./bootstrap.sh    # Symlink all packages to ~/
brew bundle        # Install Homebrew packages
source ~/.zshrc    # Reload shell
```
