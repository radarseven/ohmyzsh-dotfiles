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
- `ssh/` — SSH config (.ssh/config, .ssh/config.d/)

Non-stowed files at repo root:
- `Brewfile` + `Brewfile.<tag>` — Homebrew packages, shared base plus per-tag layers
- `bootstrap.sh` — Prompt for the machine profile, stow all packages to ~/
- `bundle.sh` — `brew bundle` the base Brewfile plus each tag's layer
- `lib/profile.zsh` — Profile helpers shared by both scripts
- `.osx` — macOS system defaults (run manually)

## Conventions

- Shell config is modular: .zshrc sources .mix-{path,exports,aliases} before oh-my-zsh, then .mix-extra after
- `.mix-extra` is private (not in repo) — used for secrets, machine-specific tools (Herd, Kiro, OpenClaw), and anything that needs `compdef`
- Aliases go in `.mix-aliases`, PATH changes in `.mix-path`, env vars in `.mix-exports`
- Stow a single package: `stow -R -d . -t ~ <package>`
- Test changes: `source ~/.zshrc`

## Machine profiles (role tags)

Machines differ by composable tags, never by hostname: one of `laptop`/`desktop` plus one of `personal`/`work`. Each machine declares its tags in an untracked file, `~/.config/dotfiles/profile` (e.g. `laptop personal`), written by `bootstrap.sh`.

Tag layers, all committed:
- Homebrew: `Brewfile.<tag>`
- Shell: `shell/.mix-tags.d/<tag>.zsh` (loaded by `.mix-tags`)
- Git: `git/.gitconfig.d/<tag>` (wired up via generated `~/.config/dotfiles/gitconfig`; re-run `bootstrap.sh` after adding one)
- SSH: `ssh/.ssh/config.d/<tag>` (gated by `Match exec` in `.ssh/config`)

The shared base reaches work-managed machines. Personal stacks, emails, hosts, and deploy tooling go behind `personal`. The repo is public: secrets still go in `~/.mix-extra`, never in a tag layer.

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
./bootstrap.sh    # Set machine profile, symlink all packages to ~/
./bundle.sh       # Install Homebrew packages for this profile
source ~/.zshrc    # Reload shell
```
